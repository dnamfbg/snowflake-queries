-- Query ID: 01c39a16-0212-67a8-24dd-0703193a175b
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:42:29.410000+00:00
-- Elapsed: 806ms
-- Environment: FBG

select count(*)
        from FBG_ANALYTICS_ENGINEERING_CI.INFORMATION_SCHEMA.schemata
        where upper(schema_name) = upper('dbt_cloud_pr_70437463747522_961__tests')
            and upper(catalog_name) = upper('FBG_ANALYTICS_ENGINEERING_CI')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "f2502d4f-2534-4d2c-a6c5-f7bafc27d1bd", "run_started_at": "2026-04-09T21:42:08.412556+00:00", "full_refresh": true, "which": "build", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497970897", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */
