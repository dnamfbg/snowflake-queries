-- Query ID: 01c39a26-0112-6806-0000-e307218bf1d6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:58:01.187000+00:00
-- Elapsed: 62ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_key_master", "node_alias": "fan_key_master", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_key_master.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_key_master", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_key_account_map", "fan_key_master_pii", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "76a033b5002b8695b7b9799d79388e3f"} */
