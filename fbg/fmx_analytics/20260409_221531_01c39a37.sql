-- Query ID: 01c39a37-0212-644a-24dd-07031941d073
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:15:31.232000+00:00
-- Elapsed: 17426ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.wallet_fmx_withdrawal_failures_hourly
    
    
    
    as (WITH withdrawals AS ( --noqa: disable=all
    SELECT
        DATE_TRUNC('hour', w.initiated_at_alk) AS activity_hour_alk,
        UPPER(COALESCE(w.status, 'UNKNOWN')) AS status,
        UPPER(COALESCE(w.payment_brand, 'UNKNOWN')) AS payment_brand,
        UPPER(COALESCE(w.gateway, 'UNKNOWN')) AS gateway,
        COALESCE(w.amount_usd, 0) AS amount_usd,
        COALESCE(acc.is_test_account, 0) AS is_test_account
    FROM FMX_ANALYTICS.STAGING.stg_fmx_withdrawals AS w
    LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts AS acc
        ON w.acco_id = acc.acco_id
    WHERE w.initiated_at_alk IS NOT NULL
),

flagged AS (
    SELECT
        activity_hour_alk,
        status,
        payment_brand,
        gateway,
        amount_usd
    FROM withdrawals
    WHERE
        COALESCE(is_test_account, 0) = 0
        AND (
            status ILIKE '%FAIL%'
            OR status ILIKE '%CANCEL%'
            OR status ILIKE '%REJECT%'
            OR status IN (
                'WITHDRAWAL_FAILURE',
                'WITHDRAWAL_REJECTED',
                'WITHDRAWAL_CANCELLED',
                'WITHDRAWAL_CANCELED_BY_USER'
            )
        )
        AND activity_hour_alk IS NOT NULL
)

SELECT
    activity_hour_alk,
    DATE(activity_hour_alk) AS activity_date_alk,
    status,
    payment_brand,
    gateway,
    COUNT(*) AS withdrawal_failure_count,
    SUM(amount_usd) AS withdrawal_failure_amount_usd
FROM flagged
GROUP BY 1, 2, 3, 4, 5
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.wallet_fmx_withdrawal_failures_hourly", "profile_name": "user", "target_name": "default"} */
