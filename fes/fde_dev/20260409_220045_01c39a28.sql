-- Query ID: 01c39a28-0112-6b51-0000-e307218c0232
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:00:45.761000+00:00
-- Elapsed: 400ms
-- Environment: FES

select * from (
        WITH topps_digital AS (
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
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_profile", "node_alias": "topps_digital_profile", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_profile.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_profile", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_final"], "materialized": "table", "raw_code_hash": "7435f9fa68b4b10d720aa90238ca69b0"} */
