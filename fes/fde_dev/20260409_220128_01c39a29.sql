-- Query ID: 01c39a29-0112-6ccc-0000-e307218bdaea
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:01:28.003000+00:00
-- Elapsed: 77ms
-- Environment: FES

select * from (
        SELECT DISTINCT fangraph_id
FROM fangraph_dev.admin.fangraph_id_final
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "unique_fangraph_ids", "node_alias": "unique_fangraph_ids", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/unique_fangraph_ids.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.unique_fangraph_ids", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_final"], "materialized": "view", "raw_code_hash": "c165129cec35b19d2ed1fb001d24e4cb"} */
