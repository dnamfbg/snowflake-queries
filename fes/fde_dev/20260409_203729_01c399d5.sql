-- Query ID: 01c399d5-0112-6bf9-0000-e3072189f6be
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:37:29.037000+00:00
-- Elapsed: 166ms
-- Environment: FES

select * from (
        WITH uuid_nodes AS (
    SELECT
        uuid_string() AS graph_uuid,
        idx,
        nodes
    FROM fangraph_dev.admin.fangraph_id_step3_subgraphs
)

SELECT
    a.graph_uuid,
    replace(b.value, '"') AS node
FROM uuid_nodes AS a, LATERAL flatten(input => a.nodes) AS b 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step4_subgraphs_exploded", "node_alias": "fangraph_id_step4_subgraphs_exploded", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step4_subgraphs_exploded.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step4_subgraphs_exploded", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step3_subgraphs"], "materialized": "table", "raw_code_hash": "b5070aa447ee3f6214622c9be4e2f3ef"} */
