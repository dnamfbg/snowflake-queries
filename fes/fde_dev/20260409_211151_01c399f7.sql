-- Query ID: 01c399f7-0112-6029-0000-e307218aebd6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:11:51.531000+00:00
-- Elapsed: 57ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_daily_fancash", "node_alias": "pfi_daily_fancash", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_daily_fancash.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_daily_fancash", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["loyalty_earn_burn_mapper", "pfi_customer_mart"], "materialized": "table", "raw_code_hash": "e4f042925148cc0f8fd666650d4f7b62"} */
