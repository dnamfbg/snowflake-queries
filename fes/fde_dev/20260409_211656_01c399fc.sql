-- Query ID: 01c399fc-0112-6806-0000-e307218b6102
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:16:56.409000+00:00
-- Elapsed: 15953ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_step7_re_fankey_candidates (
            "CURRENT_FANGRAPH_ID", "PROPOSED_FANGRAPH_ID", "NODE"
          )
          select
            
              __src."CURRENT_FANGRAPH_ID", 
            
              __src."PROPOSED_FANGRAPH_ID", 
            
              __src."NODE"
            
          from ( SELECT *
FROM fangraph_dev.admin.fangraph_id_step6_consistent_ids
WHERE LEFT(node, 3) = 'fk-' 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step7_re_fankey_candidates", "node_alias": "fangraph_id_step7_re_fankey_candidates", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step7_re_fankey_candidates.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step7_re_fankey_candidates", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step6_consistent_ids"], "materialized": "table", "raw_code_hash": "575ba8474895a9594a7787f8a198ef49"} */
