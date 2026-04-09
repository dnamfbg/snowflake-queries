-- Query ID: 01c39a32-0112-6b51-0000-e307218c8d3e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:10:57.047000+00:00
-- Elapsed: 20849ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_commerce_fan_key_master (
            "PRIVATE_FAN_ID", "COMMERCE_ACCOUNT_EMAIL", "COMMERCE_MOBILE_NUMBER", "COMMERCE_HASHED_EMAIL", "COMMERCE_ACCOUNT_TYPE", "COMMERCE_BILLING_STREET_ADDRESS1", "COMMERCE_BILLING_STREET_ADDRESS2", "COMMERCE_BILLING_CITY", "COMMERCE_BILLING_STATE", "COMMERCE_BILLING_COUNTRY", "COMMERCE_BILLING_ZIP_CODE", "COMMERCE_BILLING_ZIP_CODE_EXTENSION", "COMMERCE_SHIPPING_STREET_ADDRESS1", "COMMERCE_SHIPPING_STREET_ADDRESS2", "COMMERCE_SHIPPING_CITY", "COMMERCE_SHIPPING_STATE", "COMMERCE_SHIPPING_COUNTRY", "COMMERCE_SHIPPING_ZIP_CODE", "COMMERCE_SHIPPING_ZIP_CODE_EXTENSION", "COMMERCE_ACCOUNT_CREATION_TIMESTAMP", "COMMERCE_ACCOUNT_LAST_MODIFIED_TIMESTAMP", "FAN_KEY_CREATED_TIMESTAMP"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."COMMERCE_ACCOUNT_EMAIL", 
            
              __src."COMMERCE_MOBILE_NUMBER", 
            
              __src."COMMERCE_HASHED_EMAIL", 
            
              __src."COMMERCE_ACCOUNT_TYPE", 
            
              __src."COMMERCE_BILLING_STREET_ADDRESS1", 
            
              __src."COMMERCE_BILLING_STREET_ADDRESS2", 
            
              __src."COMMERCE_BILLING_CITY", 
            
              __src."COMMERCE_BILLING_STATE", 
            
              __src."COMMERCE_BILLING_COUNTRY", 
            
              __src."COMMERCE_BILLING_ZIP_CODE", 
            
              __src."COMMERCE_BILLING_ZIP_CODE_EXTENSION", 
            
              __src."COMMERCE_SHIPPING_STREET_ADDRESS1", 
            
              __src."COMMERCE_SHIPPING_STREET_ADDRESS2", 
            
              __src."COMMERCE_SHIPPING_CITY", 
            
              __src."COMMERCE_SHIPPING_STATE", 
            
              __src."COMMERCE_SHIPPING_COUNTRY", 
            
              __src."COMMERCE_SHIPPING_ZIP_CODE", 
            
              __src."COMMERCE_SHIPPING_ZIP_CODE_EXTENSION", 
            
              __src."COMMERCE_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."COMMERCE_ACCOUNT_LAST_MODIFIED_TIMESTAMP", 
            
              __src."FAN_KEY_CREATED_TIMESTAMP"
            
          from ( SELECT
    fkfim.fan_id AS private_fan_id,
    fkm.account_email AS commerce_account_email,
    fkm.mobile_number AS commerce_mobile_number,
    fkm.hashed_email AS commerce_hashed_email,
    fkm.account_type AS commerce_account_type,
    fkm.billing_street_address1 AS commerce_billing_street_address1,
    fkm.billing_street_address2 AS commerce_billing_street_address2,
    fkm.billing_city AS commerce_billing_city,
    fkm.billing_state AS commerce_billing_state,
    fkm.billing_country AS commerce_billing_country,
    fkm.billing_zip_code AS commerce_billing_zip_code,
    fkm.billing_zip_code_extension AS commerce_billing_zip_code_extension,
    fkm.shipping_street_address1 AS commerce_shipping_street_address1,
    fkm.shipping_street_address2 AS commerce_shipping_street_address2,
    fkm.shipping_city AS commerce_shipping_city,
    fkm.shipping_state AS commerce_shipping_state,
    fkm.shipping_country AS commerce_shipping_country,
    fkm.shipping_zip_code AS commerce_shipping_zip_code,
    fkm.shipping_zip_code_extension AS commerce_shipping_zip_code_extension,
    MIN(fkm.creation_time_ts) OVER (PARTITION BY fkfim.fan_id) AS commerce_account_creation_timestamp,
    MAX(fkm.last_modified_ts) OVER (PARTITION BY fkfim.fan_id) AS commerce_account_last_modified_timestamp,
    fkm.creation_time_ts AS fan_key_created_timestamp
FROM fangraph_dev.admin.fan_key_master AS fkm
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_key_fan_id_map AS fkfim
    ON fkm.fan_key = fkfim.fan_key
WHERE fkfim.fan_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY fkfim.fan_id
    ORDER BY fkm.last_modified_ts DESC NULLS LAST
) = 1 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_fan_key_master", "node_alias": "pfi_commerce_fan_key_master", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_fan_key_master.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_fan_key_master", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_fan_key_master", "fan_key_fan_id_map"], "materialized": "table", "raw_code_hash": "be092458a98eed86e95f85ac2d58884b"} */
