-- Query ID: 01c39a37-0212-6e7d-24dd-070319418997
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:15:30.256000+00:00
-- Elapsed: 6994ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.orders_order_failures_hourly
    
    
    
    as (WITH base AS ( --noqa: disable=all
    SELECT
        er.order_id,
        o.account_id,
        o.symbol,
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', er.created_at)) AS activity_hour,
        UPPER(COALESCE(er.report_type, 'UNKNOWN')) AS report_type,
        COALESCE(NULLIF(TRIM(er.reason), ''), 'UNKNOWN_REASON') AS failure_reason
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er
    INNER JOIN FMX_ANALYTICS.STAGING.stg_fmx_orders AS o
        ON er.order_id = o.order_id
    LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts AS a
        ON o.account_id::varchar = a.acco_id
    WHERE
        COALESCE(a.is_test_account, 0) = 0
        AND (
            er.quantity = 0
            OR UPPER(er.report_type) IN ('REJECT', 'REJECTED', 'CANCEL', 'CANCELLED', 'CANCEL_REJECT', 'ERROR')
        )
),

aggregated AS (
    SELECT
        activity_hour,
        report_type,
        failure_reason,
        COUNT(*) AS failure_count,
        COUNT(DISTINCT order_id) AS failed_orders,
        COUNT(DISTINCT account_id) AS affected_accounts,
        COUNT(DISTINCT symbol) AS affected_symbols
    FROM base
    GROUP BY 1, 2, 3
),

windowed AS (
    SELECT
        ag.*,
        SUM(failure_count) OVER (
            PARTITION BY report_type, failure_reason
            ORDER BY activity_hour
            ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
        ) AS failure_count_24h,
        SUM(failure_count) OVER (
            PARTITION BY report_type, failure_reason
            ORDER BY activity_hour
            ROWS BETWEEN 167 PRECEDING AND CURRENT ROW
        ) AS failure_count_7d
    FROM aggregated AS ag
)

SELECT
    activity_hour,
    report_type,
    failure_reason,
    failure_count,
    failed_orders,
    affected_accounts,
    affected_symbols,
    failure_count_24h,
    failure_count_7d,
    DATE(activity_hour) AS activity_date
FROM windowed
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.orders_order_failures_hourly", "profile_name": "user", "target_name": "default"} */
