-- Query ID: 01c399d7-0112-6bf9-0000-e3072189f75e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:39:43.915000+00:00
-- Elapsed: 408ms
-- Environment: FES

select * from (
        WITH relationships AS (
    SELECT
        fan_id,
        fan_key,
        account_id
    FROM fangraph_dev.admin.fangraph_id_step1_id_mapping_counts
    WHERE COALESCE(fan_id_count, 0) <= 1 AND COALESCE(fan_key_count, 0) <= 1 AND COALESCE(account_id_count, 0) <= 1
),

distinct_nodes AS (
    SELECT
        UUID_STRING() AS uuid,
        -- we don't need to cover every case as every case isn't possible
        CASE
            WHEN fan_id IS NOT NULL AND fan_key IS NOT NULL AND account_id IS NOT NULL
                THEN ARRAY_CONSTRUCT(CONCAT('fi-', fan_id), CONCAT('fk-', fan_key), CONCAT('ai-', account_id))
            WHEN fan_id IS NULL AND fan_key IS NOT NULL AND account_id IS NOT NULL
                THEN ARRAY_CONSTRUCT(CONCAT('fk-', fan_key), CONCAT('ai-', account_id))
            WHEN fan_id IS NOT NULL AND fan_key IS NULL AND account_id IS NULL
                THEN ARRAY_CONSTRUCT(CONCAT('fi-', fan_id))
            ELSE  --  fan_id is null and fan_key is not null and account_id is null THEN
                ARRAY_CONSTRUCT(CONCAT('fk-', fan_key))
        END AS nodes
    FROM relationships
),

nodes_exploded AS (
    SELECT
        a.uuid AS default_uuid,
        REPLACE(b.value, '"') AS node
    FROM distinct_nodes AS a, LATERAL FLATTEN(input => a.nodes) AS b
),

grouped_uuids AS (
    SELECT
        default_uuid AS fangraph_id,
        node
    FROM nodes_exploded
    UNION ALL
    SELECT
        graph_uuid AS fangraph_id,
        node
    FROM fangraph_dev.admin.fangraph_id_step4_subgraphs_exploded
)

SELECT
    MIN(fangraph_id) AS fangraph_id,
    node
FROM grouped_uuids
GROUP BY ALL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step5_new_mapping", "node_alias": "fangraph_id_step5_new_mapping", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step5_new_mapping.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step5_new_mapping", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step1_id_mapping_counts", "fangraph_id_step4_subgraphs_exploded"], "materialized": "table", "raw_code_hash": "4d5f1dc4dc178ff07de2222d171f8f74"} */
