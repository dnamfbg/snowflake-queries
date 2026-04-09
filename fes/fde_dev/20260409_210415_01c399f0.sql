-- Query ID: 01c399f0-0112-6b51-0000-e307218a669e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:04:15.320000+00:00
-- Elapsed: 3999ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_step2_id_mapping_for_graph (
            "FAN_ID", "FAN_KEY", "ACCOUNT_ID"
          )
          select
            
              __src."FAN_ID", 
            
              __src."FAN_KEY", 
            
              __src."ACCOUNT_ID"
            
          from ( SELECT
    fan_id,
    fan_key,
    account_id
FROM fangraph_dev.admin.fangraph_id_step1_id_mapping_counts
WHERE fan_id_count > 1 OR fan_key_count > 1 OR account_id_count > 1 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step2_id_mapping_for_graph", "node_alias": "fangraph_id_step2_id_mapping_for_graph", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step2_id_mapping_for_graph.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step2_id_mapping_for_graph", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_step1_id_mapping_counts"], "materialized": "table", "raw_code_hash": "26c3c5c1476445067c7feec5294f9071"} */
