-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe3eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:27.232000+00:00
-- Elapsed: 1209ms
-- Run Count: 2
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_fmx_withdrawals
  
  
  
  
  as (
    WITH withdrawals AS (
    SELECT
        id::varchar AS withdrawal_id,
        account_id::varchar AS acco_id,
        transaction_ref,
        amount::float AS amount_usd,
        initiated_at AS initiated_at_utc,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', initiated_at)::timestamp_ntz AS initiated_at_alk,
        submitted_at AS submitted_at_utc,
        completed_at AS completed_at_utc,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', completed_at)::timestamp_ntz AS completed_at_alk,
        currency,
        jurisdictions_id,
        error_source,
        error_code,
        gateway,
        payment_brand,
        modified,
        CASE
            WHEN UPPER(status) = 'WITHDRAWAL_COMPLETED' AND UPPER(product) = 'EXCHANGE'
                THEN
                    CASE
                        WHEN payment_brand = 'CARD' THEN 0.75
                        WHEN payment_brand = 'TRUSTLY' THEN 0.5
                        ELSE 0
                    END
            ELSE 0
        END AS payment_processing_cost,
        UPPER(product) AS product,
        UPPER(COALESCE(status, 'UNKNOWN')) AS status,
        LAG(UPPER(COALESCE(status, 'UNKNOWN')))
            OVER (PARTITION BY account_id ORDER BY initiated_at)
            AS prev_transaction_status,
        LAG(initiated_at) OVER (PARTITION BY account_id ORDER BY initiated_at) AS prev_transaction_initiated_at_utc
    FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS
    WHERE
        COALESCE(is_deleted, 0) = 0
)

SELECT
    withdrawal_id,
    acco_id,
    transaction_ref,
    amount_usd,
    payment_processing_cost,
    initiated_at_utc,
    initiated_at_alk,
    submitted_at_utc,
    completed_at_utc,
    completed_at_alk,
    currency,
    jurisdictions_id,
    error_source,
    error_code,
    gateway,
    payment_brand,
    modified,
    product,
    status,
    COALESCE(
        status IN ('WITHDRAWAL_FAILURE', 'WITHDRAWAL_REJECTED', 'WITHDRAWAL_CANCELLED', 'WITHDRAWAL_CANCELED_BY_USER')
        AND prev_transaction_status IN (
            'WITHDRAWAL_FAILURE', 'WITHDRAWAL_REJECTED', 'WITHDRAWAL_CANCELLED', 'WITHDRAWAL_CANCELED_BY_USER'
        )
        AND DATEDIFF('second', prev_transaction_initiated_at_utc, initiated_at_utc) <= 3600,
        FALSE
    ) AS is_repeat_failure_one_hour
FROM withdrawals
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_fmx_withdrawals", "profile_name": "user", "target_name": "default"} */
