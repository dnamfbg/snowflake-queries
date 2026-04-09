-- Query ID: 01c39a19-0112-6be5-0000-e307218bb65a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:45:04.429000+00:00
-- Elapsed: 13754ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_final (
            "NODE", "FANGRAPH_ID"
          )
          select
            
              __src."NODE", 
            
              __src."FANGRAPH_ID"
            
          from ( SELECT
    node,
    fangraph_id
FROM fangraph_dev.admin.fangraph_id_step13_re_fankey_final

UNION ALL

SELECT
    node,
    fangraph_id
FROM fangraph_dev.admin.fangraph_id_step14_topps

UNION ALL

SELECT
    node,
    fangraph_id
FROM fangraph_dev.admin.fangraph_id_step15_events

UNION ALL

SELECT
    node,
    fangraph_id
FROM fangraph_dev.admin.fangraph_id_step16_collect 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_final", "node_alias": "fangraph_id_final", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_final.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_final", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step13_re_fankey_final", "fangraph_id_step14_topps", "fangraph_id_step15_events", "fangraph_id_step16_collect"], "materialized": "table", "raw_code_hash": "982917c3d5fa956a78d8df553db2a2ce"} */
