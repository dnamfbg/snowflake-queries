-- Query ID: 01c399c9-0112-6806-0000-e30721897d22
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:25:51.402000+00:00
-- Elapsed: 128ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_favorites", "node_alias": "pfi_fbg_favorites", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_favorites.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_favorites", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "d840bc61b21df97c44446028b93ee3cd"} */
