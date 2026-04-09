-- Query ID: 01c39a33-0112-6be5-0000-e307218ce4f6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:11:48.209000+00:00
-- Elapsed: 331ms
-- Environment: FES

select * from (
        WITH topps_digital_fangraph AS (
    SELECT *
    FROM fangraph_dev.topps_digital.topps_digital_profile
),

aggregate_fields AS (
    SELECT
        fangraph_id,
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
        SUM(IFF(app_name = 'baseball', usd_purchase_amount_lifetime, NULL)) AS topps_digital_baseball_spend_amount_lifetime,
        
    ARRAY_AGG(DISTINCT user_profile_key ) WITHIN GROUP (ORDER BY user_profile_key )
 AS topps_user_profile_keys,
        COUNT(DISTINCT user_profile_key) AS topps_user_profile_keys_cnt,
        
    ARRAY_AGG(DISTINCT topps_digital_user_id ) WITHIN GROUP (ORDER BY topps_digital_user_id )
 AS topps_digital_user_ids,
        COUNT(DISTINCT topps_digital_user_id) AS topps_digital_user_ids_cnt
    FROM topps_digital_fangraph
    GROUP BY ALL
),

latest_starwars AS (
    SELECT
        fangraph_id,
        spend_cohort_lifetime AS topps_digital_starwars_spend_cohort_lifetime,
        coins_balance AS topps_digital_starwars_coins_balance,
        gems_balance AS topps_digital_starwars_gems_balance
    FROM topps_digital_fangraph
    WHERE app_name = 'starwars'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fangraph_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_marvel AS (
    SELECT
        fangraph_id,
        spend_cohort_lifetime AS topps_digital_marvel_spend_cohort_lifetime,
        coins_balance AS topps_digital_marvel_coins_balance,
        gems_balance AS topps_digital_marvel_gems_balance
    FROM topps_digital_fangraph
    WHERE app_name = 'marvel'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fangraph_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_disney AS (
    SELECT
        fangraph_id,
        spend_cohort_lifetime AS topps_digital_disney_spend_cohort_lifetime,
        coins_balance AS topps_digital_disney_coins_balance,
        gems_balance AS topps_digital_disney_gems_balance
    FROM topps_digital_fangraph
    WHERE app_name = 'disney'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fangraph_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_wwe AS (
    SELECT
        fangraph_id,
        spend_cohort_lifetime AS topps_digital_wwe_spend_cohort_lifetime,
        coins_balance AS topps_digital_wwe_coins_balance,
        gems_balance AS topps_digital_wwe_gems_balance
    FROM topps_digital_fangraph
    WHERE app_name = 'wwe'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fangraph_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

latest_baseball AS (
    SELECT
        fangraph_id,
        spend_cohort_lifetime AS topps_digital_baseball_spend_cohort_lifetime,
        coins_balance AS topps_digital_baseball_coins_balance,
        gems_balance AS topps_digital_baseball_gems_balance
    FROM topps_digital_fangraph
    WHERE app_name = 'baseball'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fangraph_id
        ORDER BY last_activity_dt DESC
    ) = 1
),

non_aggregate_fields AS (
    SELECT
        fangraph_id,
        user_name AS topps_digital_username,
        COALESCE(topps_digital_fan_id_email, topps_digital_email) AS topps_digital_email,
        topps_digital_email_opt_in,
        primary_city AS topps_digital_city,
        primary_state AS topps_digital_state,
        primary_country AS topps_digital_country,
        best_fangraph_record
    FROM topps_digital_fangraph
)

SELECT
    aggregate_fields.fangraph_id,
    non_aggregate_fields.* EXCLUDE (fangraph_id),
    aggregate_fields.* EXCLUDE (fangraph_id),
    latest_starwars.* EXCLUDE (fangraph_id),
    latest_marvel.* EXCLUDE (fangraph_id),
    latest_disney.* EXCLUDE (fangraph_id),
    latest_wwe.* EXCLUDE (fangraph_id),
    latest_baseball.* EXCLUDE (fangraph_id)
FROM aggregate_fields
INNER JOIN non_aggregate_fields
    USING (fangraph_id)
LEFT JOIN latest_starwars
    USING (fangraph_id)
LEFT JOIN latest_marvel
    USING (fangraph_id)
LEFT JOIN latest_disney
    USING (fangraph_id)
LEFT JOIN latest_wwe
    USING (fangraph_id)
LEFT JOIN latest_baseball
    USING (fangraph_id) 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_profile_aggregated", "node_alias": "topps_digital_profile_aggregated", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_profile_aggregated.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_profile_aggregated", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_digital_profile"], "materialized": "table", "raw_code_hash": "027358fe73c057a3ff25b6daef6b9afb"} */
