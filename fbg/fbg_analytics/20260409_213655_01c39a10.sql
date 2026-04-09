-- Query ID: 01c39a10-0212-6b00-24dd-07031938a677
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:36:55.944000+00:00
-- Elapsed: 420ms
-- Environment: FBG

select count(*)
        from FBG_ANALYTICS.INFORMATION_SCHEMA.schemata
        where upper(schema_name) = upper('CASINO__tests')
            and upper(catalog_name) = upper('FBG_ANALYTICS')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "cb602e88-f585-4df8-ae75-6b33d339fbef", "run_started_at": "2026-04-09T21:36:37.880060+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463720946", "dbt_cloud_run_id": "70437497970613", "dbt_cloud_run_reason_category": "other", "dbt_cloud_run_reason": "Triggered by completion of run 70437497968840"} */
