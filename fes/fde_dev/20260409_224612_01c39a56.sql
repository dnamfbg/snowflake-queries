-- Query ID: 01c39a56-0112-6544-0000-e307218d579a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:46:12.016000+00:00
-- Elapsed: 5936ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fanapp_login (
            "PRIVATE_FAN_ID", "FANAPP_FIRST_LOGIN_TS", "FANAPP_LAST_LOGIN_TS"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FANAPP_FIRST_LOGIN_TS", 
            
              __src."FANAPP_LAST_LOGIN_TS"
            
          from ( SELECT
    fitm.fan_id AS private_fan_id,
    TO_TIMESTAMP(MIN(a.event_ts)) AS fanapp_first_login_ts,
    TO_TIMESTAMP(MAX(a.event_ts)) AS fanapp_last_login_ts
FROM FANFLOW_DEV.ACCOUNT_EVENTS.signin__account AS a
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
    ON a.tenant_fan_id = fitm.tenant_fan_id
WHERE
    a.site_id IN (609465, 609659)
    AND fitm.tenant_id = 100005
GROUP BY ALL 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fanapp_login", "node_alias": "pfi_fanapp_login", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fanapp_login.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fanapp_login", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["signin__account", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "da0fabb9e807319308ca510f727197ed"} */
