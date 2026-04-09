-- Query ID: 01c399eb-0112-6be5-0000-e3072189de7a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:59:38.319000+00:00
-- Elapsed: 1967ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fanapp_session (
            "PRIVATE_FAN_ID", "FANAPP_SESSION_LAST_TS"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FANAPP_SESSION_LAST_TS"
            
          from ( SELECT
    fitm.fan_id AS private_fan_id,
    TO_TIMESTAMP(MAX(register.user_session_start_ts)) AS fanapp_session_last_ts
FROM MONTEROSA_DEV.MONTEROSA_CORE.fanapp_register_dtl AS register
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
    ON register.tenant_fan_id = fitm.tenant_fan_id
WHERE
    register.user_session_start_ts IS NOT NULL
    AND fitm.tenant_id = 100005
GROUP BY fitm.fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fanapp_session", "node_alias": "pfi_fanapp_session", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fanapp_session.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fanapp_session", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fanapp_register_dtl", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "9854eb455ecadb1739d85c40bb48606b"} */
