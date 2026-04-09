-- Query ID: 01c399e8-0112-6be5-0000-e3072189ddca
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:56:33.061000+00:00
-- Elapsed: 521ms
-- Environment: FES

select * from (
        WITH crm_notifs AS (
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
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_crm", "node_alias": "pfi_commerce_crm", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_crm.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_crm", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_key_fan_id_map"], "materialized": "table", "raw_code_hash": "ad6da0a18f66b86d68c6527f092b5b30"} */
