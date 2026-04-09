-- Query ID: 01c399fd-0112-6be5-0000-e307218b293a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:17:45.355000+00:00
-- Elapsed: 5451ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_step9_re_fankey_multi_cluster (
            "PROPOSED_FANGRAPH_ID", "CURRENT_FANGRAPH_ID", "RESOLVED_FANGRAPH_ID", "NODE"
          )
          select
            
              __src."PROPOSED_FANGRAPH_ID", 
            
              __src."CURRENT_FANGRAPH_ID", 
            
              __src."RESOLVED_FANGRAPH_ID", 
            
              __src."NODE"
            
          from ( WITH fangraph_ids_with_multiple_clusters AS (

    SELECT
        current_fangraph_id,
        COUNT(DISTINCT proposed_fangraph_id) AS proposed_fangraph_id_count
    FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates
    GROUP BY ALL
    HAVING proposed_fangraph_id_count > 1

),

min_proposed_fangraph_id AS (

    SELECT
        c.current_fangraph_id,
        MIN(c.proposed_fangraph_id) AS min_proposed_fangraph_id
    FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates AS c
    INNER JOIN fangraph_ids_with_multiple_clusters AS f
        ON c.current_fangraph_id = f.current_fangraph_id
    GROUP BY ALL

)

SELECT
    c.proposed_fangraph_id,
    c.current_fangraph_id,
    m.current_fangraph_id AS resolved_fangraph_id,
    c.node
FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates AS c
INNER JOIN min_proposed_fangraph_id AS m
    ON c.proposed_fangraph_id = m.min_proposed_fangraph_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step9_re_fankey_multi_cluster", "node_alias": "fangraph_id_step9_re_fankey_multi_cluster", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step9_re_fankey_multi_cluster.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step9_re_fankey_multi_cluster", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step7_re_fankey_candidates"], "materialized": "table", "raw_code_hash": "af2941358c530b0d000bc144dd7d12d1"} */
