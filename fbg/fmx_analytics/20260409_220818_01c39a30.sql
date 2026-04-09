-- Query ID: 01c39a30-0212-6dbe-24dd-0703193fc2a7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:18.223000+00:00
-- Elapsed: 479ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_transaction_balance_info
  
  
  
  
  as (
    SELECT
    id::number(38, 0) AS id,
    acco_id::varchar AS acco_id,
    jurisdictions_id::number(38, 0) AS jurisdictions_id,
    trans_date,
    cash_balance,
    dw_last_updated
FROM FBG_ANALYTICS_ENGINEERING.TRANSACTIONS.TRANSACTION_BALANCE_INFO
WHERE trans_date IS NOT NULL
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_transaction_balance_info", "profile_name": "user", "target_name": "default"} */
