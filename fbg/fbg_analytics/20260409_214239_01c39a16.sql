-- Query ID: 01c39a16-0212-6b00-24dd-0703193a51e7
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:42:39.235000+00:00
-- Elapsed: 809ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_MODELS" select * from "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409214216593051"
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "cb602e88-f585-4df8-ae75-6b33d339fbef", "run_started_at": "2026-04-09T21:36:37.880060+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463720946", "dbt_cloud_run_id": "70437497970613", "dbt_cloud_run_reason_category": "other", "dbt_cloud_run_reason": "Triggered by completion of run 70437497968840"} */;
