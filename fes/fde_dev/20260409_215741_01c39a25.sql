-- Query ID: 01c39a25-0112-6544-0000-e307218bac96
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:57:41.168000+00:00
-- Elapsed: 419ms
-- Environment: FES

select * from (
        WITH live_fans AS (
    SELECT tenant_fan_id
    FROM fangraph_dev.live.users
    WHERE tenant_fan_id IS NOT NULL
)

SELECT
    fangraph_ids.fangraph_id,
    fitm.fan_id AS fanid_private_fan_id,
    fitm.* EXCLUDE fan_id,
    coalesce(lf.tenant_fan_id IS NOT NULL, FALSE) AS live_fan_indicator
FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids
    ON fangraph_ids.node = 'fi-' || fitm.fan_id
LEFT JOIN live_fans AS lf
    ON fitm.tenant_fan_id = lf.tenant_fan_id
QUALIFY row_number() OVER (
    PARTITION BY fitm.tenant_id, fitm.tenant_fan_id
    ORDER BY fitm.creation_time ASC
) = 1 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_id_tenant_map", "node_alias": "fan_id_tenant_map", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_id_tenant_map.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_id_tenant_map", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["live_users", "fan_id_tenant_map", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "150940f4fd7f8298fcf96123a70d3339"} */
