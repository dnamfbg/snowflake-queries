-- Query ID: 01c399e5-0112-6806-0000-e307218a171e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:53:29.208000+00:00
-- Elapsed: 5943ms
-- Environment: FES

select * from (
        SELECT
    *,
    current_timestamp AS snapshot_ts
FROM fangraph_dev.admin.fangraph
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_snapshots", "node_alias": "fangraph_snapshots", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_snapshots.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_snapshots", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": [], "materialized": "incremental", "raw_code_hash": "62e17f0406b30af34fb805fd97cac954"} */
