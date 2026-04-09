-- Query ID: 01c39a09-0212-6dbe-24dd-07031936967f
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:29:38.735000+00:00
-- Elapsed: 594ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.customer_mart
  
  
  
  
  as (
    select * from FBG_ANALYTICS_ENGINEERING.CUSTOMERS.customer_mart
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "customer_mart", "node_alias": "customer_mart", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/customer/marts/customer_mart.sql", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "model.dbt_analytics_engineering.customer_mart", "node_resource_type": "model", "node_meta": {"cost_center": "Product"}, "node_tags": ["customer", "view"], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "node_refs": ["customer_demographics_and_information", "customer_registration", "customer_marketing_and_acquisition", "customer_product_preferences", "customer_betting_activity", "customer_vip_and_segmentation", "customer_acquisition_and_tracking", "customer_financial_information", "customer_pointsbet_metrics", "bronze__fde_fbg_info_fbg_affiliate_ftusf"], "materialized": "view", "raw_code_hash": "9330847207cd6a68720954831052c3b3", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */;
