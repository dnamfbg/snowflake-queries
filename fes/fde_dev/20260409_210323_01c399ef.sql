-- Query ID: 01c399ef-0112-6ccc-0000-e307218a9126
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:03:23.441000+00:00
-- Elapsed: 216ms
-- Environment: FES

select * from (
        SELECT DISTINCT
    user_profile_key,
    topps_digital_user_id
FROM collectibles_fde.topps_digital.store_item_user_purchases_daily_vw 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_id_mapping", "node_alias": "topps_digital_id_mapping", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_id_mapping.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_id_mapping", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": [], "materialized": "table", "raw_code_hash": "862a739e23e896d683ebfb3384b9ca95"} */
