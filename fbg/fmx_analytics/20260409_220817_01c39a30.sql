-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe203
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:17.272000+00:00
-- Elapsed: 3346ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.stg_xtremepush_profiles
    
    
    
    as (SELECT
    user_id,
    customer_id::VARCHAR AS acco_id
FROM fbg_source.xtremepush.profiles
WHERE customer_id IS NOT NULL
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_xtremepush_profiles", "profile_name": "user", "target_name": "default"} */
