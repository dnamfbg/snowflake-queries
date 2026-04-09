-- Query ID: 01c39a35-0212-67a9-24dd-07031940eeab
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:13:21.680000+00:00
-- Elapsed: 1424ms
-- Environment: FBG

select artifacts_model, metadata_hash from "FBG_ANALYTICS"."CASINO"."DBT_ARTIFACTS_HASHES"
    order by metadata_hash
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "c83c61c2-4d20-426f-9f09-c79b4714129f", "run_started_at": "2026-04-09T22:08:15.570990+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463735798", "dbt_cloud_run_id": "70437497973472", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
