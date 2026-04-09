-- Query ID: 01c39a32-0212-6cb9-24dd-070319403817
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:10:15.663000+00:00
-- Elapsed: 1025ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_MODELS" select * from "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409220946015719"
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "b6334721-30b6-4647-b0db-602f87672cae", "run_started_at": "2026-04-09T22:08:15.424441+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685041", "dbt_cloud_run_id": "70437497973459", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */;
