-- Query ID: 01c39a0a-0212-6b00-24dd-07031936f337
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:30:35.005000+00:00
-- Elapsed: 1163ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.stg_fanapp_reg_info
  
  
  
  
  as (
    select * from FBG_ANALYTICS_ENGINEERING.STAGING.stg_fanapp_reg_info
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "stg_fanapp_reg_info", "node_alias": "stg_fanapp_reg_info", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/customer/staging/stg_fanapp_reg_info.sql", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "model.dbt_analytics_engineering.stg_fanapp_reg_info", "node_resource_type": "model", "node_meta": {"cost_center": "Product"}, "node_tags": ["view"], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "node_refs": ["stg_fanapp_tenant_id"], "materialized": "view", "raw_code_hash": "2db11e736104d7dff4adbe9c445b98ff", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */;
