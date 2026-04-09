-- Query ID: 01c399f4-0212-6e7d-24dd-07031931c1b7
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:08:39+00:00
-- Elapsed: 324ms
-- Environment: FBG

select count(*)
        from FBG_ANALYTICS.INFORMATION_SCHEMA.schemata
        where upper(schema_name) = upper('CASINO__tests')
            and upper(catalog_name) = upper('FBG_ANALYTICS')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "0d6fedc4-7351-444c-be2e-615007381edb", "run_started_at": "2026-04-09T21:08:19.716234+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463735798", "dbt_cloud_run_id": "70437497968255", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
