-- Query ID: 01c39a32-0112-6806-0000-e307218c9cde
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:10:23.299000+00:00
-- Elapsed: 74ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_key_master_best_fangraph_record", "node_alias": "fan_key_master_best_fangraph_record", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_key_master_best_fangraph_record.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_key_master_best_fangraph_record", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_fan_key_master"], "materialized": "table", "raw_code_hash": "7734bc0b9cb1fc2720ea49e35679c40a"} */
