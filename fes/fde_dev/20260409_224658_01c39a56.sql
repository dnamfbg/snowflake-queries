-- Query ID: 01c39a56-0112-6b51-0000-e307218d4d22
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:46:58.259000+00:00
-- Elapsed: 184ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_accounts", "node_alias": "pfi_fbg_accounts", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_accounts.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_accounts", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "8e537add93c83378ac6f62442baa9624"} */
