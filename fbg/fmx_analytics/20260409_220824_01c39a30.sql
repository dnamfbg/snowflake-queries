-- Query ID: 01c39a30-0212-67a8-24dd-0703193fa837
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:24.151000+00:00
-- Elapsed: 910ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_fmx_account_segments
  
  
  
  
  as (
    WITH account_segments AS (
    SELECT
        accounts_id::varchar AS acco_id,
        customer_segments_id::number AS customer_segment_id,
        created AS created_at_utc,
        convert_timezone('UTC', 'America/Anchorage', created) AS created_at_alk
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS
)

SELECT
    seg.acco_id,
    seg.customer_segment_id,
    cs.segment_name,
    cs.enterprise_product,
    seg.created_at_utc,
    seg.created_at_alk,
    date(seg.created_at_alk) AS created_date_alk
FROM account_segments AS seg
LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_customer_segments AS cs
    ON seg.customer_segment_id = cs.customer_segment_id
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_fmx_account_segments", "profile_name": "user", "target_name": "default"} */
