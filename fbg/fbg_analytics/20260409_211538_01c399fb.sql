-- Query ID: 01c399fb-0212-6cb9-24dd-07031933b227
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:15:38.634000+00:00
-- Elapsed: 375ms
-- Environment: FBG

select count(*)
        from FBG_ANALYTICS.INFORMATION_SCHEMA.schemata
        where upper(schema_name) = upper('CASINO__tests')
            and upper(catalog_name) = upper('FBG_ANALYTICS')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "906951ca-6255-46c9-a666-4129ac48200c", "run_started_at": "2026-04-09T21:15:18.737155+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685452", "dbt_cloud_run_id": "70437497968840", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
