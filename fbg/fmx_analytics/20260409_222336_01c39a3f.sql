-- Query ID: 01c39a3f-0212-6e7d-24dd-07031943404f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:23:36.938000+00:00
-- Elapsed: 486ms
-- Run Count: 18
-- Environment: FBG

select "database_name"||'.'||"schema_name"||'.'||"name" as sql_tag_name from table(result_scan(last_query_id()))
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "user", "target_name": "default"} */
