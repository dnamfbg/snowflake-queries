-- Query ID: 01c39a13-0112-6b51-0000-e307218b7c5a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:39:41.703000+00:00
-- Elapsed: 88ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "dim_commerce_browse_disaggregated", "node_alias": "dim_commerce_browse_disaggregated", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_commerce_browse_disaggregated.sql", "node_database": "fangraph_dev", "node_schema": "commerce", "node_id": "model.fes_data.dim_commerce_browse_disaggregated", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fanapp_daily_products", "exp_prod_fankey_map", "fangraph_fan_key_account_map", "site_lkp"], "materialized": "table", "raw_code_hash": "1b949264fa91b120bba7ef5a13ea1b7b"} */
