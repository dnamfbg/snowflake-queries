-- Query ID: 01c39a4b-0112-6f82-0000-e307218d0bfa
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:35:18.980000+00:00
-- Elapsed: 514ms
-- Environment: FES

select * from (
        SELECT
    *,
    current_timestamp AS snapshot_ts
FROM fangraph_dev.admin.fangraph
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_snapshots", "node_alias": "fangraph_snapshots", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_snapshots.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_snapshots", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": [], "materialized": "incremental", "raw_code_hash": "62e17f0406b30af34fb805fd97cac954"} */
