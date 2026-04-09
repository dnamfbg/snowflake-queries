-- Query ID: 01c39a0a-0212-6cb9-24dd-07031936e32f
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:30:15.070000+00:00
-- Elapsed: 1898ms
-- Environment: FBG

create or replace
      
      table FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.silver__promotions_bonus_campaigns
      clone FBG_ANALYTICS_ENGINEERING.PROMOTIONS.silver__promotions_bonus_campaigns
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "silver__promotions_bonus_campaigns", "node_alias": "silver__promotions_bonus_campaigns", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/promotions/silver/silver__promotions_bonus_campaigns.sql", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "model.dbt_analytics_engineering.silver__promotions_bonus_campaigns", "node_resource_type": "model", "node_meta": {"contains_pii": false, "cost_center": "Analytics Engineering"}, "node_tags": ["view", "analytics-engineering-daily", "promotions"], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "node_refs": ["bronze__osb_source_bonus_campaigns", "bronze__static_sheets_bonus_campaign_details"], "materialized": "table", "raw_code_hash": "809b9e149d82a60073afa83356059d91", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */
