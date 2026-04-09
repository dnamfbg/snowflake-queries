-- Query ID: 01c39a0b-0212-6b00-24dd-07031936f8af
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:31:07.762000+00:00
-- Elapsed: 428ms
-- Environment: FBG

select artifacts_model, metadata_hash from "FBG_ANALYTICS_DEV"."KATE_SMOLKO"."DBT_ARTIFACTS_HASHES"
    order by metadata_hash
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "181f48aa-19fc-4bf0-b2ae-e91ec6cc6daf", "run_started_at": "2026-04-09T21:30:57.798057+00:00", "full_refresh": true, "which": "run"} */
