-- Query ID: 01c399fb-0112-6f44-0000-e307218b18d2
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:15:57.267000+00:00
-- Elapsed: 614ms
-- Environment: FES

select * from (
        WITH current_mapping AS (
    SELECT
        fangraph.fangraph_id,
        CONCAT('fi-', fan_id.value) AS node
    FROM fangraph_dev.admin.fangraph AS fangraph,
        LATERAL FLATTEN(input => fangraph.fanid_private_fan_ids) AS fan_id
    UNION ALL
    SELECT
        fangraph.fangraph_id,
        CONCAT('fk-', fan_key.value) AS node
    FROM fangraph_dev.admin.fangraph AS fangraph,
        LATERAL FLATTEN(input => fangraph.fan_keys) AS fan_key
    UNION ALL
    SELECT
        fangraph.fangraph_id,
        CONCAT('ai-', account_id.value) AS node
    FROM fangraph_dev.admin.fangraph AS fangraph,
        LATERAL FLATTEN(input => fangraph.account_ids) AS account_id
),

new_current_mapping_map AS (
    SELECT
        new_mapping.fangraph_id AS proposed_fangraph_id,
        current_mapping.fangraph_id AS current_fangraph_id
    FROM fangraph_dev.admin.fangraph_id_step5_new_mapping AS new_mapping
    INNER JOIN current_mapping
        ON new_mapping.node = current_mapping.node
),

consistent_fangraph_id AS (
    SELECT
        proposed_fangraph_id,
        MIN(current_fangraph_id) AS current_fangraph_id
    FROM new_current_mapping_map
    GROUP BY ALL
)

SELECT
    consistent_fangraph_id.current_fangraph_id,
    new_mapping.fangraph_id AS proposed_fangraph_id,
    new_mapping.node
FROM fangraph_dev.admin.fangraph_id_step5_new_mapping AS new_mapping
LEFT JOIN consistent_fangraph_id
    ON new_mapping.fangraph_id = consistent_fangraph_id.proposed_fangraph_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step6_consistent_ids", "node_alias": "fangraph_id_step6_consistent_ids", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step6_consistent_ids.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step6_consistent_ids", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step5_new_mapping"], "materialized": "table", "raw_code_hash": "fe60298d4223f24cc805f0eeacc905b5"} */
