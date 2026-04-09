-- Query ID: 01c399f5-0212-6b00-24dd-07031931ac93
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:09:51.249000+00:00
-- Elapsed: 1303ms
-- Environment: FBG

create or replace temporary table "FBG_ANALYTICS"."CASINO"."DBT_MODELS__tmp_20260409210951242566"
         as
        (
        SELECT
        
            *
        
        FROM "FBG_ANALYTICS"."CASINO"."DBT_MODELS"
        WHERE 1 = 0
    
            
    

        )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "744c3dd3-a1ae-40a2-bf88-a255f90d78e0", "run_started_at": "2026-04-09T21:08:14.767234+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685041", "dbt_cloud_run_id": "70437497968252", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */;
