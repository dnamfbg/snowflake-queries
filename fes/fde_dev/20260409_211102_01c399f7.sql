-- Query ID: 01c399f7-0112-6f44-0000-e307218b1596
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:11:02.587000+00:00
-- Elapsed: 62ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_customer_mart", "node_alias": "pfi_customer_mart", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_customer_mart.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_customer_mart", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_tenant_id_mapping", "pfi_ftu_dates", "pfi_user_profile"], "materialized": "table", "raw_code_hash": "5cf5cff4d281e709e1b841826b5cafa2"} */
