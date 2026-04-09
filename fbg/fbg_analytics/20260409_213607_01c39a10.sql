-- Query ID: 01c39a10-0212-6e7d-24dd-0703193883e3
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:36:07.436000+00:00
-- Elapsed: 877ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_MODELS" select * from "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409213546625781"
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "906951ca-6255-46c9-a666-4129ac48200c", "run_started_at": "2026-04-09T21:15:18.737155+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685452", "dbt_cloud_run_id": "70437497968840", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */;
