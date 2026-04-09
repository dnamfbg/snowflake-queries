-- Query ID: 01c39a09-0212-6cb9-24dd-070319365cf3
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:29:10.258000+00:00
-- Elapsed: 2302ms
-- Environment: FBG

select artifacts_model, metadata_hash from "FBG_ANALYTICS_DEV"."KATE_SMOLKO"."DBT_ARTIFACTS_HASHES"
    order by metadata_hash
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "ec27300b-a226-4a22-a177-661ed8e981a0", "run_started_at": "2026-04-09T21:28:58.048674+00:00", "full_refresh": true, "which": "run"} */
