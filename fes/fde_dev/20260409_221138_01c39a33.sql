-- Query ID: 01c39a33-0112-6bf9-0000-e307218cf386
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:11:38.150000+00:00
-- Elapsed: 3949ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_topps_digital (
            "PRIVATE_FAN_ID", "TOPPS_DIGITAL_USERNAME", "TOPPS_DIGITAL_EMAIL", "TOPPS_DIGITAL_EMAIL_OPT_IN", "TOPPS_DIGITAL_CITY", "TOPPS_DIGITAL_STATE", "TOPPS_DIGITAL_COUNTRY", "TOPPS_DIGITAL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_MARVEL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_DISNEY_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_WWE_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_BASEBALL_ACCOUNT_CREATION_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_MARVEL_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_DISNEY_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_WWE_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_BASEBALL_LAST_ACTIVITY_TIMESTAMP", "TOPPS_DIGITAL_STARWARS_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_MARVEL_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_DISNEY_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_WWE_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_BASEBALL_SPEND_AMOUNT_LIFETIME", "TOPPS_DIGITAL_STARWARS_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_STARWARS_COINS_BALANCE", "TOPPS_DIGITAL_STARWARS_GEMS_BALANCE", "TOPPS_DIGITAL_MARVEL_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_MARVEL_COINS_BALANCE", "TOPPS_DIGITAL_MARVEL_GEMS_BALANCE", "TOPPS_DIGITAL_DISNEY_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_DISNEY_COINS_BALANCE", "TOPPS_DIGITAL_DISNEY_GEMS_BALANCE", "TOPPS_DIGITAL_WWE_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_WWE_COINS_BALANCE", "TOPPS_DIGITAL_WWE_GEMS_BALANCE", "TOPPS_DIGITAL_BASEBALL_SPEND_COHORT_LIFETIME", "TOPPS_DIGITAL_BASEBALL_COINS_BALANCE", "TOPPS_DIGITAL_BASEBALL_GEMS_BALANCE"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
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
            
          from ( WITH topps_digital_pfi AS (
    SELECT
        fitm.fan_id AS private_fan_id,
        td.*
    FROM fangraph_dev.topps_digital.topps_digital_profile AS td
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON td.tenant_fan_id = fitm.tenant_fan_id
    WHERE fitm.fan_id IS NOT NULL
),

aggregate_fields AS (
    SELECT
        private_fan_id,
        MIN(TO_TIMESTAMP(user_activation_dt)) AS topps_digital_account_creation_timestamp,
        MIN(IFF(app_name = 'starwars', TO_TIMESTAMP(user_activation_dt), NULL)) AS topps_digital_starwars_account_creation_timestamp,
        MIN(IFF(app_name = 'marvel', TO_TIMESTAMP(user_activation_dt), NULL)) AS topps_digital_marvel_account_creation_timestamp,
        MIN(IFF(app_name = 'disney', TO_TIMESTAMP(user_activation_dt), NULL)) AS topps_digital_disney_account_creation_timestamp,
        MIN(IFF(app_name = 'wwe', TO_TIMESTAMP(user_activation_dt), NULL)) AS topps_digital_wwe_account_creation_timestamp,
        MIN(IFF(app_name = 'baseball', TO_TIMESTAMP(user_activation_dt), NULL)) AS topps_digital_baseball_account_creation_timestamp,
        MAX(IFF(app_name = 'starwars', TO_TIMESTAMP(last_activity_dt), NULL)) AS topps_digital_starwars_last_activity_timestamp,
        MAX(IFF(app_name = 'marvel', TO_TIMESTAMP(last_activity_dt), NULL)) AS topps_digital_marvel_last_activity_timestamp,
        MAX(IFF(app_name = 'disney', TO_TIMESTAMP(last_activity_dt), NULL)) AS topps_digital_disney_last_activity_timestamp,
        MAX(IFF(app_name = 'wwe', TO_TIMESTAMP(last_activity_dt), NULL)) AS topps_digital_wwe_last_activity_timestamp,
        MAX(IFF(app_name = 'baseball', TO_TIMESTAMP(last_activity_dt), NULL)) AS topps_digital_baseball_last_activity_timestamp,
        SUM(IFF(app_name = 'starwars', usd_purchase_amount_lifetime, NULL)) AS topps_digital_starwars_spend_amount_lifetime,
        SUM(IFF(app_name = 'marvel', usd_purchase_amount_lifetime, NULL)) AS topps_digital_marvel_spend_amount_lifetime,
        SUM(IFF(app_name = 'disney', usd_purchase_amount_lifetime, NULL)) AS topps_digital_disney_spend_amount_lifetime,
        SUM(IFF(app_name = 'wwe', usd_purchase_amount_lifetime, NULL)) AS topps_digital_wwe_spend_amount_lifetime,
        SUM(IFF(app_name = 'baseball', usd_purchase_amount_lifetime, NULL)) AS topps_digital_baseball_spend_amount_lifetime
    FROM topps_digital_pfi
    GROUP BY private_fan_id
),

latest_starwars AS (
    SELECT
        private_fan_id,
        spend_cohort_lifetime AS topps_digital_starwars_spend_cohort_lifetime,
        coins_balance AS topps_digital_starwars_coins_balance,
        gems_balance AS topps_digital_starwars_gems_balance
    FROM topps_digital_pfi
    WHERE app_name = 'starwars'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_marvel AS (
    SELECT
        private_fan_id,
        spend_cohort_lifetime AS topps_digital_marvel_spend_cohort_lifetime,
        coins_balance AS topps_digital_marvel_coins_balance,
        gems_balance AS topps_digital_marvel_gems_balance
    FROM topps_digital_pfi
    WHERE app_name = 'marvel'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_disney AS (
    SELECT
        private_fan_id,
        spend_cohort_lifetime AS topps_digital_disney_spend_cohort_lifetime,
        coins_balance AS topps_digital_disney_coins_balance,
        gems_balance AS topps_digital_disney_gems_balance
    FROM topps_digital_pfi
    WHERE app_name = 'disney'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_wwe AS (
    SELECT
        private_fan_id,
        spend_cohort_lifetime AS topps_digital_wwe_spend_cohort_lifetime,
        coins_balance AS topps_digital_wwe_coins_balance,
        gems_balance AS topps_digital_wwe_gems_balance
    FROM topps_digital_pfi
    WHERE app_name = 'wwe'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_baseball AS (
    SELECT
        private_fan_id,
        spend_cohort_lifetime AS topps_digital_baseball_spend_cohort_lifetime,
        coins_balance AS topps_digital_baseball_coins_balance,
        gems_balance AS topps_digital_baseball_gems_balance
    FROM topps_digital_pfi
    WHERE app_name = 'baseball'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

non_aggregate_fields AS (
    SELECT
        private_fan_id,
        user_name AS topps_digital_username,
        COALESCE(topps_digital_fan_id_email, topps_digital_email) AS topps_digital_email,
        topps_digital_email_opt_in,
        primary_city AS topps_digital_city,
        primary_state AS topps_digital_state,
        primary_country AS topps_digital_country
    FROM topps_digital_pfi
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY
            CASE WHEN topps_digital_fan_id_email IS NOT NULL THEN 1 ELSE 0 END DESC,
            last_activity_dt DESC NULLS LAST
    ) = 1
)

SELECT
    aggregate_fields.private_fan_id,
    non_aggregate_fields.topps_digital_username,
    non_aggregate_fields.topps_digital_email,
    non_aggregate_fields.topps_digital_email_opt_in,
    non_aggregate_fields.topps_digital_city,
    non_aggregate_fields.topps_digital_state,
    non_aggregate_fields.topps_digital_country,
    aggregate_fields.topps_digital_account_creation_timestamp,
    aggregate_fields.topps_digital_starwars_account_creation_timestamp,
    aggregate_fields.topps_digital_marvel_account_creation_timestamp,
    aggregate_fields.topps_digital_disney_account_creation_timestamp,
    aggregate_fields.topps_digital_wwe_account_creation_timestamp,
    aggregate_fields.topps_digital_baseball_account_creation_timestamp,
    aggregate_fields.topps_digital_starwars_last_activity_timestamp,
    aggregate_fields.topps_digital_marvel_last_activity_timestamp,
    aggregate_fields.topps_digital_disney_last_activity_timestamp,
    aggregate_fields.topps_digital_wwe_last_activity_timestamp,
    aggregate_fields.topps_digital_baseball_last_activity_timestamp,
    aggregate_fields.topps_digital_starwars_spend_amount_lifetime,
    aggregate_fields.topps_digital_marvel_spend_amount_lifetime,
    aggregate_fields.topps_digital_disney_spend_amount_lifetime,
    aggregate_fields.topps_digital_wwe_spend_amount_lifetime,
    aggregate_fields.topps_digital_baseball_spend_amount_lifetime,
    latest_starwars.topps_digital_starwars_spend_cohort_lifetime,
    latest_starwars.topps_digital_starwars_coins_balance,
    latest_starwars.topps_digital_starwars_gems_balance,
    latest_marvel.topps_digital_marvel_spend_cohort_lifetime,
    latest_marvel.topps_digital_marvel_coins_balance,
    latest_marvel.topps_digital_marvel_gems_balance,
    latest_disney.topps_digital_disney_spend_cohort_lifetime,
    latest_disney.topps_digital_disney_coins_balance,
    latest_disney.topps_digital_disney_gems_balance,
    latest_wwe.topps_digital_wwe_spend_cohort_lifetime,
    latest_wwe.topps_digital_wwe_coins_balance,
    latest_wwe.topps_digital_wwe_gems_balance,
    latest_baseball.topps_digital_baseball_spend_cohort_lifetime,
    latest_baseball.topps_digital_baseball_coins_balance,
    latest_baseball.topps_digital_baseball_gems_balance
FROM aggregate_fields
INNER JOIN non_aggregate_fields USING (private_fan_id)
LEFT JOIN latest_starwars USING (private_fan_id)
LEFT JOIN latest_marvel USING (private_fan_id)
LEFT JOIN latest_disney USING (private_fan_id)
LEFT JOIN latest_wwe USING (private_fan_id)
LEFT JOIN latest_baseball USING (private_fan_id) 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_digital", "node_alias": "pfi_topps_digital", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_digital.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_digital", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_digital_profile", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "16c232845f260d90f19bf2f8eed19867"} */
