-- Query ID: 01c39a37-0212-644a-24dd-07031941d20b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:15:50.740000+00:00
-- Elapsed: 21111ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.fct_fmx_execution_failures_daily_v2
    
    
    
    as (WITH hourly AS (
    SELECT
        activity_date,
        report_type,
        failure_reason,
        failure_count,
        failed_orders,
        affected_accounts,
        affected_symbols
    FROM FMX_ANALYTICS.CUSTOMER.orders_order_failures_hourly
)

SELECT
    activity_date,
    report_type,
    failure_reason,
    SUM(failure_count) AS failure_count,
    SUM(failed_orders) AS failed_orders,
    SUM(affected_accounts) AS affected_accounts,
    SUM(affected_symbols) AS affected_symbols,
    DATEADD('day', 1, activity_date) AS report_date
FROM hourly
GROUP BY
    activity_date,
    report_type,
    failure_reason
ORDER BY activity_date, report_type, failure_reason
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_execution_failures_daily_v2", "profile_name": "user", "target_name": "default"} */
