-- Query ID: 01c39a33-0212-67a8-24dd-07031940a3df
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:11:14.834000+00:00
-- Elapsed: 1868ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_withdrawal_failures_daily
    
    
    
    as (SELECT
    status,
    payment_brand,
    gateway,
    withdrawal_count,
    withdrawal_amount_usd,
    DATEADD('day', 1, activity_date) AS report_date
FROM FMX_ANALYTICS.CUSTOMER.int_fmx_withdrawal_failures_daily
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_withdrawal_failures_daily", "profile_name": "user", "target_name": "default"} */
