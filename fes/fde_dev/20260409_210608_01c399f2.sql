-- Query ID: 01c399f2-0112-6ccc-0000-e307218a96c6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:06:08.455000+00:00
-- Elapsed: 1250ms
-- Environment: FES

select * from (
        WITH topps_pfi AS (
    SELECT
        fitm.fan_id AS private_fan_id,
        topps.c_id AS topps_com_customer_id,
        topps.c_fan_id AS topps_com_fan_id,
        topps.c_legacy_id AS topps_com_legacy_customer_id,
        topps.c_firstname AS topps_com_first_name,
        topps.c_lastname AS topps_com_last_name,
        topps.c_dob AS topps_com_dob,
        topps.c_email AS topps_com_email,
        TRY_TO_NUMBER(REPLACE(LTRIM(topps.c_phone, '+'), ' ', '')) AS topps_com_phone,
        topps.c_billing_address1 AS topps_com_billing_address1,
        topps.c_billing_address2 AS topps_com_billing_address2,
        topps.c_billing_city AS topps_com_billing_city,
        topps.c_billing_postcode AS topps_com_billing_zip,
        topps.c_billing_region AS topps_com_billing_region,
        topps.c_billing_country AS topps_com_billing_country,
        TO_TIMESTAMP(topps.c_created_at) AS topps_com_created_timestamp,
        TO_TIMESTAMP(topps.c_updated_at) AS topps_com_updated_timestamp
    FROM fangraph_dev.topps.topps_dim_customer AS topps
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON topps.c_fan_id = fitm.tenant_fan_id
    WHERE fitm.fan_id IS NOT NULL
)

SELECT
    private_fan_id,
    topps_com_customer_id,
    topps_com_fan_id,
    topps_com_first_name,
    topps_com_last_name,
    topps_com_dob,
    topps_com_email,
    topps_com_phone,
    topps_com_billing_address1,
    topps_com_billing_address2,
    topps_com_billing_city,
    topps_com_billing_zip,
    topps_com_billing_region,
    topps_com_billing_country,
    MIN(topps_com_created_timestamp) OVER (PARTITION BY private_fan_id) AS topps_com_created_timestamp,
    MAX(topps_com_updated_timestamp) OVER (PARTITION BY private_fan_id) AS topps_com_updated_timestamp
FROM topps_pfi
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY private_fan_id
    ORDER BY topps_com_updated_timestamp DESC NULLS LAST
) = 1 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_com", "node_alias": "pfi_topps_com", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_com.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_com", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_dim_customer", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "cd6d095d768f74f4f75fa3d05f741171"} */
