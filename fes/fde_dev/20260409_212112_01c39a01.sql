-- Query ID: 01c39a01-0112-6bf9-0000-e307218b4912
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:21:12.294000+00:00
-- Elapsed: 523ms
-- Environment: FES

select * from (
        WITH resolved_fan_keys AS (

    SELECT DISTINCT
        proposed_fangraph_id,
        resolved_fangraph_id
    FROM fangraph_dev.admin.fangraph_id_step11_re_fankey_resolved


),

non_fankey_nodes AS (

    SELECT *
    FROM fangraph_dev.admin.fangraph_id_step6_consistent_ids
    WHERE LEFT(node, 3) <> 'fk-'

)

SELECT
    n.proposed_fangraph_id,
    r.resolved_fangraph_id,
    n.node
FROM resolved_fan_keys AS r
INNER JOIN non_fankey_nodes AS n
    ON r.proposed_fangraph_id = n.proposed_fangraph_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step12_assign_nodes", "node_alias": "fangraph_id_step12_assign_nodes", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step12_assign_nodes.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step12_assign_nodes", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step11_re_fankey_resolved", "fangraph_id_step6_consistent_ids"], "materialized": "table", "raw_code_hash": "9feb0694d374e7372b6ae83ffe5144b3"} */
