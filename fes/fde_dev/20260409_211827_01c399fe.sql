-- Query ID: 01c399fe-0112-65b6-0000-e307218b51c6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:18:27.238000+00:00
-- Elapsed: 400ms
-- Environment: FES

select * from (
        SELECT
    fangraph_ids.resolved_fangraph_id AS fangraph_id,
    fkam.fan_key,
    fkam.hashed_email,
    fkam.account_email,
    fkam.account_id,
    fkam.site_id,
    MIN(fkam.creation_time) AS creation_time,
    MAX(fkam.last_modified_time) AS last_modified_time,
    MAX_BY(fkam.is_primary_account, fkam.last_modified_time) AS is_primary_account,
    MAX_BY(fkam.is_guest, fkam.last_modified_time) AS is_guest
FROM COMMERCE_DEV.FAN_KEY.fan_key_account_map AS fkam
INNER JOIN fangraph_dev.admin.fangraph_id_step11_re_fankey_resolved AS fangraph_ids
    ON fangraph_ids.node = 'fk-' || fkam.fan_key
GROUP BY
    fangraph_ids.resolved_fangraph_id,
    fkam.fan_key,
    fkam.hashed_email,
    fkam.account_email,
    fkam.account_id,
    fkam.site_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_key_account_map", "node_alias": "fan_key_account_map", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_key_account_map.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_key_account_map", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_key_account_map", "fangraph_id_step11_re_fankey_resolved"], "materialized": "table", "raw_code_hash": "c66a5a6af800a30552f1f5af70e177f8"} */
