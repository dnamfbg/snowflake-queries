-- Query ID: 01c399f6-0212-644a-24dd-070319326323
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:10:33.715000+00:00
-- Elapsed: 1176ms
-- Environment: FBG

delete from "FBG_ANALYTICS"."CASINO"."DBT_MODELS"
            where
            metadata_hash is null
            or metadata_hash in (select metadata_hash from "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409210945372499")
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "744c3dd3-a1ae-40a2-bf88-a255f90d78e0", "run_started_at": "2026-04-09T21:08:14.767234+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685041", "dbt_cloud_run_id": "70437497968252", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */;
