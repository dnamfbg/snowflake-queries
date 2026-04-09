-- Query ID: 01c399f9-0212-6cb9-24dd-0703193312df
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:13:31.207000+00:00
-- Elapsed: 1433ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_INVOCATIONS"
         (INVOCATION_ID,JOB_ID,JOB_NAME,JOB_RUN_ID,RUN_STARTED_AT,RUN_COMPLETED_AT,GENERATED_AT,CREATED_AT,COMMAND,DBT_VERSION,ELEMENTARY_VERSION,FULL_REFRESH,INVOCATION_VARS,VARS,TARGET_NAME,TARGET_DATABASE,TARGET_SCHEMA,TARGET_PROFILE_NAME,THREADS,SELECTED,YAML_SELECTOR,PROJECT_ID,PROJECT_NAME,ENV,ENV_ID,CAUSE_CATEGORY,CAUSE,PULL_REQUEST_ID,GIT_SHA,ORCHESTRATOR,DBT_USER,JOB_URL,JOB_RUN_URL,ACCOUNT_ID,TARGET_ADAPTER_SPECIFIC_FIELDS) values
    ('745e7718-e5c4-4d83-b60a-11215749b8ff','70437463685004',NULL,'70437497966890','2026-04-09 21:00:28','2026-04-09 21:13:31','2026-04-09 21:13:31',
  current_timestamp::timestamp
,'build','2026.4.7+4533730','0.18.3',False,'{}','{}','default','FBG_ANALYTICS','CASINO','user',10,'["tag:analysts-fourhours"]',NULL,'70437463656039','dbt_casino','prod',NULL,'scheduled','scheduled',NULL,NULL,'dbt_cloud',NULL,'https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/jobs/70437463685004','https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/runs/70437497966890',NULL,'{"warehouse": "BI_L_WH", "user": "DBT_CLOUD_ETL", "role": "SNOWFLAKE-SVC_DBT_CLOUD_ETL_ROLE"}')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "745e7718-e5c4-4d83-b60a-11215749b8ff", "run_started_at": "2026-04-09T21:00:28.680710+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685004", "dbt_cloud_run_id": "70437497966890", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
