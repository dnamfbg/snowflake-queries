-- Query ID: 01c39a10-0212-6cb9-24dd-070319389423
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:36:13.037000+00:00
-- Elapsed: 889ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_INVOCATIONS"
         (INVOCATION_ID,JOB_ID,JOB_NAME,JOB_RUN_ID,RUN_STARTED_AT,RUN_COMPLETED_AT,GENERATED_AT,CREATED_AT,COMMAND,DBT_VERSION,ELEMENTARY_VERSION,FULL_REFRESH,INVOCATION_VARS,VARS,TARGET_NAME,TARGET_DATABASE,TARGET_SCHEMA,TARGET_PROFILE_NAME,THREADS,SELECTED,YAML_SELECTOR,PROJECT_ID,PROJECT_NAME,ENV,ENV_ID,CAUSE_CATEGORY,CAUSE,PULL_REQUEST_ID,GIT_SHA,ORCHESTRATOR,DBT_USER,JOB_URL,JOB_RUN_URL,ACCOUNT_ID,TARGET_ADAPTER_SPECIFIC_FIELDS) values
    ('906951ca-6255-46c9-a666-4129ac48200c','70437463685452',NULL,'70437497968840','2026-04-09 21:15:18','2026-04-09 21:36:12','2026-04-09 21:36:12',
  current_timestamp::timestamp
,'build','2026.4.7+4533730','0.18.3',False,'{}','{}','default','FBG_ANALYTICS','CASINO','user',8,'["tag:analysts-fourhours-ledger"]',NULL,'70437463656039','dbt_casino','prod',NULL,'scheduled','scheduled',NULL,NULL,'dbt_cloud',NULL,'https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/jobs/70437463685452','https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/runs/70437497968840',NULL,'{"warehouse": "BI_L_WH", "user": "DBT_CLOUD_ETL", "role": "SNOWFLAKE-SVC_DBT_CLOUD_ETL_ROLE"}')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "906951ca-6255-46c9-a666-4129ac48200c", "run_started_at": "2026-04-09T21:15:18.737155+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685452", "dbt_cloud_run_id": "70437497968840", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
