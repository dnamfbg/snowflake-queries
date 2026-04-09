-- Query ID: 01c39a34-0112-6544-0000-e307218cc916
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:12:08.912000+00:00
-- Elapsed: 422ms
-- Environment: FES

select * from (
        SELECT * EXCLUDE (best_fangraph_record)
FROM fangraph_dev.topps_digital.topps_digital_profile_aggregated
WHERE best_fangraph_record = 1 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_profile_best_fangraph_record", "node_alias": "topps_digital_profile_best_fangraph_record", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_profile_best_fangraph_record.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_profile_best_fangraph_record", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_digital_profile_aggregated"], "materialized": "table", "raw_code_hash": "4b232a42e4a0507b59584531ef86d4d0"} */
