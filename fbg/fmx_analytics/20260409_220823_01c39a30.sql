-- Query ID: 01c39a30-0212-6dbe-24dd-0703193fc35f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:23.006000+00:00
-- Elapsed: 994ms
-- Run Count: 2
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_fmx_order_status
  
  
  
  
  as (
    WITH status_ranked AS (
    SELECT
        er.order_id AS fbg_order_id,
        coalesce(er.report_type, 'UNKNOWN') AS ord_status,
        CASE coalesce(er.report_type, 'UNKNOWN')
            WHEN 'NEW' THEN 1
            WHEN 'TRADE' THEN 2
            WHEN 'CANCELLED' THEN 3
            WHEN 'REJECTED' THEN 4
            ELSE 0
        END AS order_status_rank
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er
)

SELECT
    fbg_order_id,
    ord_status,
    order_status_rank
FROM status_ranked
QUALIFY row_number() OVER (
    PARTITION BY fbg_order_id
    ORDER BY order_status_rank DESC
) = 1
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_fmx_order_status", "profile_name": "user", "target_name": "default"} */
