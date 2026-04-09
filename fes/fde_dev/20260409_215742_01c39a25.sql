-- Query ID: 01c39a25-0112-6be5-0000-e307218bba16
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:57:42.283000+00:00
-- Elapsed: 13880ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fan_id_tenant_map (
            "FANGRAPH_ID", "FANID_PRIVATE_FAN_ID", "FANAPI_ACCOUNT_ID", "TENANT_FAN_ID", "TENANT_ID", "HASHED_EMAIL", "USER_ACCOUNT_ID", "USER_ACCOUNT_DIRECTORY_ID", "CRM_ACCOUNT_DIRECTORY_ID", "LOYALTY_ACCOUNT_DIRECTORY_ID", "SURROGATE_ACCOUNT_KEY", "TENANT_CREATED_DATE", "TENANT_MODIFIED_DATE", "LAST_MODIFIED_TIME", "CREATION_TIME", "LIVE_FAN_INDICATOR"
          )
          select
            
              __src."FANGRAPH_ID", 
            
              __src."FANID_PRIVATE_FAN_ID", 
            
              __src."FANAPI_ACCOUNT_ID", 
            
              __src."TENANT_FAN_ID", 
            
              __src."TENANT_ID", 
            
              __src."HASHED_EMAIL", 
            
              __src."USER_ACCOUNT_ID", 
            
              __src."USER_ACCOUNT_DIRECTORY_ID", 
            
              __src."CRM_ACCOUNT_DIRECTORY_ID", 
            
              __src."LOYALTY_ACCOUNT_DIRECTORY_ID", 
            
              __src."SURROGATE_ACCOUNT_KEY", 
            
              __src."TENANT_CREATED_DATE", 
            
              __src."TENANT_MODIFIED_DATE", 
            
              __src."LAST_MODIFIED_TIME", 
            
              __src."CREATION_TIME", 
            
              __src."LIVE_FAN_INDICATOR"
            
          from ( WITH live_fans AS (
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
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_id_tenant_map", "node_alias": "fan_id_tenant_map", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_id_tenant_map.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_id_tenant_map", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["live_users", "fan_id_tenant_map", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "150940f4fd7f8298fcf96123a70d3339"} */
