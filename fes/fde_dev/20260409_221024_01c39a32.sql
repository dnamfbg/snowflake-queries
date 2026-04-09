-- Query ID: 01c39a32-0112-6806-0000-e307218c9ce6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:10:24.017000+00:00
-- Elapsed: 26746ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fan_key_master_best_fangraph_record (
            "FANGRAPH_ID", "FAN_KEY", "ACCOUNT_EMAIL", "SCRUBBED_EMAIL", "MOBILE_NUMBER", "FIRST_NAME", "LAST_NAME", "BILLING_ADDRESS_ID", "BILLING_STREET_ADDRESS1", "BILLING_STREET_ADDRESS2", "BILLING_CITY", "BILLING_STATE", "BILLING_COUNTRY", "BILLING_ZIP_CODE", "BILLING_ZIP_CODE_EXTENSION", "SHIPPING_ADDRESS_ID", "SHIPPING_STREET_ADDRESS1", "SHIPPING_STREET_ADDRESS2", "SHIPPING_CITY", "SHIPPING_STATE", "SHIPPING_COUNTRY", "SHIPPING_ZIP_CODE", "SHIPPING_ZIP_CODE_EXTENSION", "HASHED_EMAIL", "INTERNAL_SURROGATE_KEY", "ACCOUNT_DIRECTORY_ID", "ACCOUNT_ID", "ACCOUNT_TYPE", "LAST_MODIFIED_TS", "CREATION_TIME_TS", "CHANGE_DATE"
          )
          select
            
              __src."FANGRAPH_ID", 
            
              __src."FAN_KEY", 
            
              __src."ACCOUNT_EMAIL", 
            
              __src."SCRUBBED_EMAIL", 
            
              __src."MOBILE_NUMBER", 
            
              __src."FIRST_NAME", 
            
              __src."LAST_NAME", 
            
              __src."BILLING_ADDRESS_ID", 
            
              __src."BILLING_STREET_ADDRESS1", 
            
              __src."BILLING_STREET_ADDRESS2", 
            
              __src."BILLING_CITY", 
            
              __src."BILLING_STATE", 
            
              __src."BILLING_COUNTRY", 
            
              __src."BILLING_ZIP_CODE", 
            
              __src."BILLING_ZIP_CODE_EXTENSION", 
            
              __src."SHIPPING_ADDRESS_ID", 
            
              __src."SHIPPING_STREET_ADDRESS1", 
            
              __src."SHIPPING_STREET_ADDRESS2", 
            
              __src."SHIPPING_CITY", 
            
              __src."SHIPPING_STATE", 
            
              __src."SHIPPING_COUNTRY", 
            
              __src."SHIPPING_ZIP_CODE", 
            
              __src."SHIPPING_ZIP_CODE_EXTENSION", 
            
              __src."HASHED_EMAIL", 
            
              __src."INTERNAL_SURROGATE_KEY", 
            
              __src."ACCOUNT_DIRECTORY_ID", 
            
              __src."ACCOUNT_ID", 
            
              __src."ACCOUNT_TYPE", 
            
              __src."LAST_MODIFIED_TS", 
            
              __src."CREATION_TIME_TS", 
            
              __src."CHANGE_DATE"
            
          from ( SELECT * EXCLUDE (best_fangraph_record)
FROM fangraph_dev.admin.fan_key_master
WHERE best_fangraph_record = 1 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_key_master_best_fangraph_record", "node_alias": "fan_key_master_best_fangraph_record", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_key_master_best_fangraph_record.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_key_master_best_fangraph_record", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_fan_key_master"], "materialized": "table", "raw_code_hash": "7734bc0b9cb1fc2720ea49e35679c40a"} */
