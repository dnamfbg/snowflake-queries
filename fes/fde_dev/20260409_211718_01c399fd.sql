-- Query ID: 01c399fd-0112-6544-0000-e307218b0bbe
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:17:18.161000+00:00
-- Elapsed: 21422ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_step8_re_fankey_one_cluster (
            "PROPOSED_FANGRAPH_ID", "CURRENT_FANGRAPH_ID", "RESOLVED_FANGRAPH_ID", "NODE"
          )
          select
            
              __src."PROPOSED_FANGRAPH_ID", 
            
              __src."CURRENT_FANGRAPH_ID", 
            
              __src."RESOLVED_FANGRAPH_ID", 
            
              __src."NODE"
            
          from ( WITH node_count AS (

    SELECT DISTINCT
        proposed_fangraph_id,
        current_fangraph_id
    FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates

),

fangraph_ids_mapping_to_one_cluster AS (

    SELECT current_fangraph_id
    FROM node_count
    WHERE current_fangraph_id IS NOT NULL
    GROUP BY ALL
    HAVING COUNT(proposed_fangraph_id) = 1

),

fangraph_id_cluster_id_one_to_one AS (

    SELECT DISTINCT
        c.current_fangraph_id,
        c.proposed_fangraph_id
    FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates AS c
    INNER JOIN fangraph_ids_mapping_to_one_cluster AS f
        ON c.current_fangraph_id = f.current_fangraph_id

)

SELECT
    c.proposed_fangraph_id,
    c.current_fangraph_id,
    o.current_fangraph_id AS resolved_fangraph_id,
    c.node
FROM fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates AS c
INNER JOIN fangraph_id_cluster_id_one_to_one AS o
    ON c.proposed_fangraph_id = o.proposed_fangraph_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step8_re_fankey_one_cluster", "node_alias": "fangraph_id_step8_re_fankey_one_cluster", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step8_re_fankey_one_cluster.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step8_re_fankey_one_cluster", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step7_re_fankey_candidates"], "materialized": "table", "raw_code_hash": "0969c96b14ec6398bff08beb940cefbd"} */
