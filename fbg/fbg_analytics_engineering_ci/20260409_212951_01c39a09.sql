-- Query ID: 01c39a09-0212-6cb9-24dd-07031936e137
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:29:51.224000+00:00
-- Elapsed: 1321ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.itm_boost_payout
  
  
  
  
  as (
    select * from FBG_ANALYTICS_ENGINEERING.STAGING.itm_boost_payout
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "itm_boost_payout", "node_alias": "itm_boost_payout", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/trading/original_structure/wager_data/itm_boost_payout.sql", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "model.dbt_analytics_engineering.itm_boost_payout", "node_resource_type": "model", "node_meta": {"cost_center": "Trading"}, "node_tags": ["sb_bet_source", "view", "trading_wagers"], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "node_refs": ["stg_trading_wagers", "itm_boost_token_payout", "itm_boost_market_payout"], "materialized": "view", "raw_code_hash": "383cf326e0ec7c96eef62cba57319245", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */;
