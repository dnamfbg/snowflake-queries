-- Query ID: 01c399d8-0112-6029-0000-e3072189af92
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:40:11.910000+00:00
-- Elapsed: 108ms
-- Environment: FES

select last_query_id() as qid
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_ecosystem_daily_activity", "node_alias": "pfi_ecosystem_daily_activity", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_ecosystem_daily_activity.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_ecosystem_daily_activity", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_customer_mart", "ticketmaster", "fanapp_user_account_id_map", "weekly_trading", "pfi_daily_fancash", "fanapp_game_results"], "materialized": "table", "raw_code_hash": "e6d88be3daaff02bc4849173a16f30d5"} */
