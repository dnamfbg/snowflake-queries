-- Query ID: 01c399f9-0212-6e7d-24dd-070319329d2b
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:13:10.866000+00:00
-- Elapsed: 797ms
-- Environment: FBG

create or replace temporary table "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409211310851040"
         as
        (
        SELECT
        
            
                metadata_hash
            
        
        FROM "FBG_ANALYTICS"."CASINO"."DBT_MODELS"
        WHERE 1 = 0
    
            
    

        )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "745e7718-e5c4-4d83-b60a-11215749b8ff", "run_started_at": "2026-04-09T21:00:28.680710+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685004", "dbt_cloud_run_id": "70437497966890", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */;
