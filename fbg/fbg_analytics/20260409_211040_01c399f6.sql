-- Query ID: 01c399f6-0212-644a-24dd-07031932645b
-- Database: FBG_ANALYTICS
-- Schema: CASINO
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:10:40.419000+00:00
-- Elapsed: 1094ms
-- Environment: FBG

insert into "FBG_ANALYTICS"."CASINO"."DBT_INVOCATIONS"
         (INVOCATION_ID,JOB_ID,JOB_NAME,JOB_RUN_ID,RUN_STARTED_AT,RUN_COMPLETED_AT,GENERATED_AT,CREATED_AT,COMMAND,DBT_VERSION,ELEMENTARY_VERSION,FULL_REFRESH,INVOCATION_VARS,VARS,TARGET_NAME,TARGET_DATABASE,TARGET_SCHEMA,TARGET_PROFILE_NAME,THREADS,SELECTED,YAML_SELECTOR,PROJECT_ID,PROJECT_NAME,ENV,ENV_ID,CAUSE_CATEGORY,CAUSE,PULL_REQUEST_ID,GIT_SHA,ORCHESTRATOR,DBT_USER,JOB_URL,JOB_RUN_URL,ACCOUNT_ID,TARGET_ADAPTER_SPECIFIC_FIELDS) values
    ('744c3dd3-a1ae-40a2-bf88-a255f90d78e0','70437463685041',NULL,'70437497968252','2026-04-09 21:08:14','2026-04-09 21:10:40','2026-04-09 21:10:40',
  current_timestamp::timestamp
,'build','2026.4.7+4533730','0.18.3',False,'{}','{}','default','FBG_ANALYTICS','CASINO','user',6,'["tag:analysts-daily-xp"]',NULL,'70437463656039','dbt_casino','prod',NULL,'scheduled','scheduled',NULL,NULL,'dbt_cloud',NULL,'https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/jobs/70437463685041','https://cloud.getdbt.com/deploy/70437463654557/projects/70437463656039/runs/70437497968252',NULL,'{"warehouse": "BI_L_WH", "user": "DBT_CLOUD_ETL", "role": "SNOWFLAKE-SVC_DBT_CLOUD_ETL_ROLE"}')
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_casino", "target_name": "default", "target_database": "FBG_ANALYTICS", "target_schema": "CASINO", "invocation_id": "744c3dd3-a1ae-40a2-bf88-a255f90d78e0", "run_started_at": "2026-04-09T21:08:14.767234+00:00", "full_refresh": false, "which": "build", "dbt_cloud_project_id": "70437463656039", "dbt_cloud_job_id": "70437463685041", "dbt_cloud_run_id": "70437497968252", "dbt_cloud_run_reason_category": "scheduled", "dbt_cloud_run_reason": "scheduled"} */
