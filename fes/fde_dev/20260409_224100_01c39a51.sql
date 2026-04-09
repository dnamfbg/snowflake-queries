-- Query ID: 01c39a51-0112-6806-0000-e307218d3a9a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:41:00.314000+00:00
-- Elapsed: 180529ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_commerce_crm (
            "PRIVATE_FAN_ID", "COMMERCE_SITE_COUNT", "COMMERCE_NOT_MAILABLE_SITE_COUNT", "COMMERCE_MAILABLE_SITE_COUNT", "COMMERCE_MAILABLE_FLAG", "COMMERCE_MAILABLE_FLAG_OPT_OUT_DATE", "COMMERCE_SUPER_SITE_RESTRICTION"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."COMMERCE_SITE_COUNT", 
            
              __src."COMMERCE_NOT_MAILABLE_SITE_COUNT", 
            
              __src."COMMERCE_MAILABLE_SITE_COUNT", 
            
              __src."COMMERCE_MAILABLE_FLAG", 
            
              __src."COMMERCE_MAILABLE_FLAG_OPT_OUT_DATE", 
            
              __src."COMMERCE_SUPER_SITE_RESTRICTION"
            
          from ( WITH crm_notifs AS (
    SELECT DISTINCT
        fan_key,
        site_id,
        mailable_flag,
        opt_in_dt,
        NULLIF(opt_out_dt, '9999-12-31') AS opt_out_dt,
        super_site_restriction
    FROM commerce_cde.cde_cust_info.fan_crm_notification_agg_v2_v
)

SELECT
    fkfim.fan_id AS private_fan_id,
    COUNT(DISTINCT crm_notifs.site_id) AS commerce_site_count,
    COUNT(DISTINCT IFF(crm_notifs.mailable_flag = FALSE, crm_notifs.site_id, NULL)) AS commerce_not_mailable_site_count,
    COUNT(DISTINCT IFF(crm_notifs.mailable_flag = TRUE, crm_notifs.site_id, NULL)) AS commerce_mailable_site_count,
    COUNT(DISTINCT IFF(crm_notifs.mailable_flag = TRUE, crm_notifs.site_id, NULL)) >= 1 AS commerce_mailable_flag,
    TO_TIMESTAMP(MAX(crm_notifs.opt_out_dt)) AS commerce_mailable_flag_opt_out_date,
    MAX(crm_notifs.super_site_restriction) AS commerce_super_site_restriction
FROM crm_notifs
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_key_fan_id_map AS fkfim
    ON crm_notifs.fan_key = fkfim.fan_key
WHERE fkfim.fan_id IS NOT NULL
GROUP BY fkfim.fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_crm", "node_alias": "pfi_commerce_crm", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_crm.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_crm", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["fan_key_fan_id_map"], "materialized": "table", "raw_code_hash": "ad6da0a18f66b86d68c6527f092b5b30"} */
