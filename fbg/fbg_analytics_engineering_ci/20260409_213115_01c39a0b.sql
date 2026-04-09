-- Query ID: 01c39a0b-0212-67a8-24dd-07031936de83
-- Database: FBG_ANALYTICS_ENGINEERING_CI
-- Schema: DBT_CLOUD_PR_70437463747522_961
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:31:15.627000+00:00
-- Elapsed: 1201ms
-- Environment: FBG

create or replace
      transient
      table FBG_ANALYTICS_ENGINEERING_CI.dbt_cloud_pr_70437463747522_961.dn_media_source_clean
      clone FBG_SOURCE.DBT_SEEDS.dn_media_source_clean
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "default", "target_database": "FBG_ANALYTICS_ENGINEERING_CI", "target_schema": "dbt_cloud_pr_70437463747522_961", "invocation_id": "62c00832-2887-426a-a5d4-1b83810115cf", "run_started_at": "2026-04-09T21:29:08.703892+00:00", "full_refresh": false, "which": "clone", "node_name": "dn_media_source_clean", "node_alias": "dn_media_source_clean", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "seeds/dn_media_source_clean.csv", "node_database": "FBG_ANALYTICS_ENGINEERING_CI", "node_schema": "dbt_cloud_pr_70437463747522_961", "node_id": "seed.dbt_analytics_engineering.dn_media_source_clean", "node_resource_type": "seed", "node_meta": {}, "node_tags": [], "invocation_command": "dbt --log-format json --debug clone -s +state:modified --exclude state:modified --target default --profile user --profiles-dir /tmp/jobs/70437497969835/.dbt --project-dir /tmp/jobs/70437497969835/target/dbt", "raw_code_hash": "d41d8cd98f00b204e9800998ecf8427e", "dbt_cloud_project_id": "70437463655479", "dbt_cloud_job_id": "70437463747522", "dbt_cloud_run_id": "70437497969835", "dbt_cloud_run_reason_category": "github_pull_request", "dbt_cloud_run_reason": "github_pull_request"} */
