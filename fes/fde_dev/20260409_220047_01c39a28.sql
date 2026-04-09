-- Query ID: 01c39a28-0112-6806-0000-e307218bf2da
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:00:47.501000+00:00
-- Elapsed: 8695ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.topps_digital.topps_digital_profile (
            "FANGRAPH_ID", "USER_NAME", "TOPPS_DIGITAL_USER_ID", "TOPPS_DIGITAL_EMAIL", "TENANT_FAN_ID", "TOPPS_DIGITAL_FAN_ID_EMAIL", "APP_NAME", "USER_PROFILE_KEY", "TOPPS_DIGITAL_EMAIL_OPT_IN", "USER_ACTIVATION_DT", "LAST_ACTIVITY_DT", "USER_ACTIVATION_OS", "RETENTION_COHORT", "IS_SPENDER", "SPEND_COHORT_LAST_30_DAYS", "USD_PURCHASE_AMOUNT_LAST_30_DAYS", "SPEND_COHORT_LIFETIME", "USD_PURCHASE_AMOUNT_LIFETIME", "AUTH_TYPE", "PRIMARY_CITY", "PRIMARY_STATE", "PRIMARY_COUNTRY", "PRIMARY_COUNTRY_TIER", "ATTRIBUTION_TYPE", "ATTRIBUTION_PARTNER", "COINS_BALANCE", "GEMS_BALANCE", "XP", "AUDIT_LAST_UPDATED_TS", "BEST_FANGRAPH_RECORD", "EMAILS_MATCH"
          )
          select
            
              __src."FANGRAPH_ID", 
            
              __src."USER_NAME", 
            
              __src."TOPPS_DIGITAL_USER_ID", 
            
              __src."TOPPS_DIGITAL_EMAIL", 
            
              __src."TENANT_FAN_ID", 
            
              __src."TOPPS_DIGITAL_FAN_ID_EMAIL", 
            
              __src."APP_NAME", 
            
              __src."USER_PROFILE_KEY", 
            
              __src."TOPPS_DIGITAL_EMAIL_OPT_IN", 
            
              __src."USER_ACTIVATION_DT", 
            
              __src."LAST_ACTIVITY_DT", 
            
              __src."USER_ACTIVATION_OS", 
            
              __src."RETENTION_COHORT", 
            
              __src."IS_SPENDER", 
            
              __src."SPEND_COHORT_LAST_30_DAYS", 
            
              __src."USD_PURCHASE_AMOUNT_LAST_30_DAYS", 
            
              __src."SPEND_COHORT_LIFETIME", 
            
              __src."USD_PURCHASE_AMOUNT_LIFETIME", 
            
              __src."AUTH_TYPE", 
            
              __src."PRIMARY_CITY", 
            
              __src."PRIMARY_STATE", 
            
              __src."PRIMARY_COUNTRY", 
            
              __src."PRIMARY_COUNTRY_TIER", 
            
              __src."ATTRIBUTION_TYPE", 
            
              __src."ATTRIBUTION_PARTNER", 
            
              __src."COINS_BALANCE", 
            
              __src."GEMS_BALANCE", 
            
              __src."XP", 
            
              __src."AUDIT_LAST_UPDATED_TS", 
            
              __src."BEST_FANGRAPH_RECORD", 
            
              __src."EMAILS_MATCH"
            
          from ( WITH topps_digital AS (
    SELECT
        user_name,
        topps_digital_user_id,
        LOWER(TRIM(topps_digital_email)) AS topps_digital_email,
        tenant_fan_id,
        LOWER(TRIM(fan_id_email)) AS topps_digital_fan_id_email,
        app_name,
        user_profile_key,
        topps_digital_email_opt_in,
        user_activation_dt,
        last_activity_dt,
        user_activation_os,
        retention_cohort,
        is_spender,
        spend_cohort_last_30_days,
        usd_purchase_amount_last_30_days,
        spend_cohort_lifetime,
        usd_purchase_amount_lifetime,
        auth_type,
        primary_city,
        primary_state,
        primary_country,
        primary_country_tier,
        attribution_type,
        attribution_partner,
        coins_balance,
        gems_balance,
        xp,
        audit_last_updated_ts
    FROM collectibles_fde.topps_digital.user_profiles_dim__next
),

topps_digital_ttf AS (
    SELECT
        user_name,
        topps_digital_user_id,
        LOWER(TRIM(topps_digital_email)) AS topps_digital_email,
        tenant_fan_id,
        LOWER(TRIM(fanid_email)) AS topps_digital_fan_id_email,
        app_name,
        user_profile_key,
        NULL AS topps_digital_email_opt_in,
        user_activation_dt,
        last_activity_dt,
        user_activation_os,
        retention_cohort,
        is_spender,
        spend_cohort_last_30_days,
        usd_purchase_amount_last_30_days,
        spend_cohort_lifetime,
        usd_purchase_amount_lifetime,
        NULL AS auth_type,
        primary_city,
        primary_state,
        primary_country,
        primary_country_tier,
        attribution_type,
        attribution_partner,
        NULL AS coins_balance,
        NULL AS gems_balance,
        NULL AS xp,
        audit_last_updated_ts
    FROM collectibles_fde.topps_digital.ttf_user_profiles_dim__next
),

unioned AS (
    SELECT * FROM topps_digital
    UNION ALL
    SELECT * FROM topps_digital_ttf
)

SELECT
    fangraph_ids.fangraph_id,
    u.*,
    COALESCE(ROW_NUMBER() OVER (
        PARTITION BY fangraph_ids.fangraph_id
        ORDER BY
            CASE WHEN u.topps_digital_fan_id_email IS NOT NULL THEN 1 ELSE 0 END,  -- prioritize fan_id_email to determine best record
            u.last_activity_dt DESC
    ) = 1, FALSE) AS best_fangraph_record,
    COALESCE(u.topps_digital_email = u.topps_digital_fan_id_email, FALSE) AS emails_match
FROM unioned AS u
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids
    ON fangraph_ids.node = 'toppsd-' || u.topps_digital_user_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_profile", "node_alias": "topps_digital_profile", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_profile.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_profile", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_final"], "materialized": "table", "raw_code_hash": "7435f9fa68b4b10d720aa90238ca69b0"} */
