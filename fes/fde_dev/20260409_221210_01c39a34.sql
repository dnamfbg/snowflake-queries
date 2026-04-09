-- Query ID: 01c39a34-0112-6f84-0000-e307218ca1ce
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:12:10.110000+00:00
-- Elapsed: 4461ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.topps_digital.topps_digital_profile_best_fangraph_record (
            "FANGRAPH_ID", "TOPPS_DIGITAL_USERNAME", "TOPPS_DIGITAL_EMAIL", "TOPPS_DIGITAL_EMAIL_OPT_IN", "TOPPS_DIGITAL_CITY", "TOPPS_DIGITAL_STATE", "TOPPS_DIGITAL_COUNTRY", "TOPPS_DIGITAL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_MARVEL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_DISNEY_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_WWE_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_BASEBALL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_MARVEL_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_DISNEY_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_WWE_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_BASEBALL_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_MARVEL_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_DISNEY_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_WWE_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_BASEBALL_SPEND_AMOUNT_LIFETIME", "TOPPS_USER_PROFILE_KEYS", "TOPPS_USER_PROFILE_KEYS_CNT", "TOPPS_DIGITAL_USER_IDS", "TOPPS_DIGITAL_USER_IDS_CNT", "TOPPS_DIGITAL_STARWARS_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_STARWARS_COINS_BALANCE", "TOPPS_DIGITAL_STARWARS_GEMS_BALANCE", "TOPPS_DIGITAL_MARVEL_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_MARVEL_COINS_BALANCE", "TOPPS_DIGITAL_MARVEL_GEMS_BALANCE", "TOPPS_DIGITAL_DISNEY_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_DISNEY_COINS_BALANCE", "TOPPS_DIGITAL_DISNEY_GEMS_BALANCE", "TOPPS_DIGITAL_WWE_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_WWE_COINS_BALANCE", "TOPPS_DIGITAL_WWE_GEMS_BALANCE", "TOPPS_DIGITAL_BASEBALL_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_BASEBALL_COINS_BALANCE", "TOPPS_DIGITAL_BASEBALL_GEMS_BALANCE"
          )
          select
            
              __src."FANGRAPH_ID", 
            
              __src."TOPPS_DIGITAL_USERNAME", 
            
              __src."TOPPS_DIGITAL_EMAIL", 
            
              __src."TOPPS_DIGITAL_EMAIL_OPT_IN", 
            
              __src."TOPPS_DIGITAL_CITY", 
            
              __src."TOPPS_DIGITAL_STATE", 
            
              __src."TOPPS_DIGITAL_COUNTRY", 
            
              __src."TOPPS_DIGITAL_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_STARWARS_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_MARVEL_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_DISNEY_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_WWE_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_BASEBALL_ACCOUNT_CREATION_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_STARWARS_LAST_ACTIVITY_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_MARVEL_LAST_ACTIVITY_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_DISNEY_LAST_ACTIVITY_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_WWE_LAST_ACTIVITY_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_BASEBALL_LAST_ACTIVITY_TIMESTAMP", 
            
              __src."TOPPS_DIGITAL_STARWARS_SPEND_AMOUNT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_MARVEL_SPEND_AMOUNT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_DISNEY_SPEND_AMOUNT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_WWE_SPEND_AMOUNT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_BASEBALL_SPEND_AMOUNT_LIFETIME", 
            
              __src."TOPPS_USER_PROFILE_KEYS", 
            
              __src."TOPPS_USER_PROFILE_KEYS_CNT", 
            
              __src."TOPPS_DIGITAL_USER_IDS", 
            
              __src."TOPPS_DIGITAL_USER_IDS_CNT", 
            
              __src."TOPPS_DIGITAL_STARWARS_SPEND_COHORT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_STARWARS_COINS_BALANCE", 
            
              __src."TOPPS_DIGITAL_STARWARS_GEMS_BALANCE", 
            
              __src."TOPPS_DIGITAL_MARVEL_SPEND_COHORT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_MARVEL_COINS_BALANCE", 
            
              __src."TOPPS_DIGITAL_MARVEL_GEMS_BALANCE", 
            
              __src."TOPPS_DIGITAL_DISNEY_SPEND_COHORT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_DISNEY_COINS_BALANCE", 
            
              __src."TOPPS_DIGITAL_DISNEY_GEMS_BALANCE", 
            
              __src."TOPPS_DIGITAL_WWE_SPEND_COHORT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_WWE_COINS_BALANCE", 
            
              __src."TOPPS_DIGITAL_WWE_GEMS_BALANCE", 
            
              __src."TOPPS_DIGITAL_BASEBALL_SPEND_COHORT_LIFETIME", 
            
              __src."TOPPS_DIGITAL_BASEBALL_COINS_BALANCE", 
            
              __src."TOPPS_DIGITAL_BASEBALL_GEMS_BALANCE"
            
          from ( SELECT * EXCLUDE (best_fangraph_record)
FROM fangraph_dev.topps_digital.topps_digital_profile_aggregated
WHERE best_fangraph_record = 1 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_profile_best_fangraph_record", "node_alias": "topps_digital_profile_best_fangraph_record", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_profile_best_fangraph_record.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_profile_best_fangraph_record", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_digital_profile_aggregated"], "materialized": "table", "raw_code_hash": "4b232a42e4a0507b59584531ef86d4d0"} */
