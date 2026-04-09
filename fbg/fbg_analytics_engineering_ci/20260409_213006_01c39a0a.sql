-- Query ID: 01c39a0a-0212-6b00-24dd-070319366f47
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:30:06.841000+00:00
-- Elapsed: 502ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.s_transactions_references
  
  
  
  
  as (
    select * from FBG_DATA_VAULT.SATS.s_transactions_references
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "s_transactions_references", "node_alias": "s_transactions_references", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/data_vault/satellites/transactions/references/s_transactions_references.sql", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "model.dbt_analytics_engineering.s_transactions_references", "node_resource_type": "model", "node_meta": {"cost_center": "Analytics Engineering"}, "node_tags": ["view", "sat", "analytics-engineering", "transaction-vault", "transaction-vault-sats", "transaction-vault-references-sats", "deprecated"], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "node_refs": ["s_transactions_references_account_statements", "s_transactions_references_fancash_earn_burn", "s_transactions_references_retail_settlements"], "materialized": "view", "raw_code_hash": "0395b5c3a2f10a3ab67d138071338c27", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */;
