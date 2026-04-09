-- Query ID: 01c399cb-0112-6029-0000-e3072189aa4a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:27:34.616000+00:00
-- Elapsed: 10626ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_user_profile (
            "PRIVATE_FAN_ID", "PFI_EMAIL", "PFI_FIRST_NAME", "PFI_LAST_NAME"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."PFI_EMAIL", 
            
              __src."PFI_FIRST_NAME", 
            
              __src."PFI_LAST_NAME"
            
          from ( WITH pfi_surrogate AS (
    SELECT DISTINCT
        fan_id AS private_fan_id,
        surrogate_account_key
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE
        fan_id IS NOT NULL
        AND surrogate_account_key IS NOT NULL
)

SELECT
    ps.private_fan_id,
    prof.profile_email AS pfi_email,
    prof.first_name AS pfi_first_name,
    prof.last_name AS pfi_last_name
FROM pfi_surrogate AS ps
INNER JOIN COMMERCE_DEV.SOURCE.crm_account AS acct
    ON ps.surrogate_account_key = acct.internal_surrogate_key
INNER JOIN COMMERCE_DEV.SOURCE.crm_profile AS prof
    ON acct.account_id = prof.account_id
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY ps.private_fan_id
    ORDER BY pfi_email ASC NULLS LAST
) = 1 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_user_profile", "node_alias": "pfi_user_profile", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_user_profile.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_user_profile", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map", "crm_account", "crm_profile"], "materialized": "table", "raw_code_hash": "d438c8a2df0a6f80c46b8ded0e58741d"} */
