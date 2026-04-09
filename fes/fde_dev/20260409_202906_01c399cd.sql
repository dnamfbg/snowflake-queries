-- Query ID: 01c399cd-0112-6029-0000-e3072189ab12
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:29:06.958000+00:00
-- Elapsed: 205ms
-- Environment: FES

select * from (
        SELECT
    fan_id,
    fan_key,
    account_id
FROM fangraph_dev.admin.fangraph_id_step1_id_mapping_counts
WHERE fan_id_count > 1 OR fan_key_count > 1 OR account_id_count > 1 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step2_id_mapping_for_graph", "node_alias": "fangraph_id_step2_id_mapping_for_graph", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step2_id_mapping_for_graph.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step2_id_mapping_for_graph", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step1_id_mapping_counts"], "materialized": "table", "raw_code_hash": "26c3c5c1476445067c7feec5294f9071"} */
