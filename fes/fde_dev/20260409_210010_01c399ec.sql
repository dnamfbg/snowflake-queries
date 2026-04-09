-- Query ID: 01c399ec-0112-6b51-0000-e307218a6436
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:00:10.302000+00:00
-- Elapsed: 23582ms
-- Environment: FES

select * from (
        WITH base AS (
    SELECT DISTINCT
        fitm.fan_id AS private_fan_id,
        fbg_acc.id AS fbg_account_id,
        fbg_acc.creation_date AS fbg_account_creation_ts,
        fbg_acc.modified AS fbg_last_modified_ts,
        fbg_acc.deleted AS fbg_account_deleted,
        UPPER(fbg_acc.status) AS fbg_status,
        TRIM(fbg_acc.name) AS fbg_name,
        INITCAP(REGEXP_SUBSTR(fbg_acc.name, '^[^ ]+')) AS fbg_first_name,
        INITCAP(TRIM(REGEXP_SUBSTR(fbg_acc.name, ' (.*)'))) AS fbg_last_name,
        fbg_acc.email AS fbg_email,
        TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:address1::VARCHAR AS fbg_address1,
        NULLIF(TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:address2::VARCHAR, '') AS fbg_address2,
        TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:address3::VARCHAR AS fbg_town,
        TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:address4::VARCHAR AS fbg_state,
        TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:postCode::VARCHAR AS fbg_zip_code,
        TRY_PARSE_JSON(fbg_acc.contact_details):ContactDetail:country::VARCHAR AS fbg_country,
        fbg_acc.country_code AS fbg_country_code,
        fbg_acc.bet_limit AS fbg_bet_limit,
        fbg_acc.live_bet_limit AS fbg_live_bet_limit,
        fbg_acc.current_jurisdictions_id AS fbg_current_jurisdictions_id,
        fbg_acc.jurisdiction_name AS fbg_jurisdiction_name,
        fbg_acc.high_level_segment AS fbg_high_level_segment,
        fbg_acc.segment AS fbg_segment,
        fbg_acc.is_pb_user AS fbg_is_pb_user,
        fbg_acc.is_data_sharing AS fbg_is_data_sharing,
        fbg_usr.kyc_completed_ts AS fbg_kyc_completed_ts,
        vip_tier.account_id AS fbg_vip_id,
        vip_tier.coded_total_tier AS fbg_vip_tiers,
        TO_TIMESTAMP(vip_tier.modified_date) AS fbg_vip_tier_modified_ts
    FROM fbg_fde.fbg_users.fbg_to_fde_accounts AS fbg_acc
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON REPLACE(fbg_acc.ref1, 'AMELCO-', '') = fitm.tenant_fan_id
    INNER JOIN fbg_fde.fbg_users.v_fbg_users AS fbg_usr
        ON fbg_acc.id = fbg_usr.acco_id
    LEFT JOIN fbg_fde.fbg_users.v_vip_tiers_aggregation AS vip_tier
        ON fbg_acc.id = vip_tier.account_id
    WHERE
        fbg_acc.creation_date IS NOT NULL
        AND fitm.tenant_id = '100002'
)

SELECT
    private_fan_id,
    fbg_account_id,
    fbg_account_creation_ts,
    fbg_last_modified_ts,
    fbg_account_deleted,
    fbg_status,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_name END AS fbg_name,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_first_name END AS fbg_first_name,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_last_name END AS fbg_last_name,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_email END AS fbg_email,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_address1 END AS fbg_address1,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_address2 END AS fbg_address2,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_town END AS fbg_town,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_state END AS fbg_state,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_zip_code END AS fbg_zip_code,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_country END AS fbg_country,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_country_code END AS fbg_country_code,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_bet_limit END AS fbg_bet_limit,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_live_bet_limit END AS fbg_live_bet_limit,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_current_jurisdictions_id END AS fbg_current_jurisdictions_id,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_jurisdiction_name END AS fbg_jurisdiction_name,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_high_level_segment END AS fbg_high_level_segment,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_segment END AS fbg_segment,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_is_pb_user END AS fbg_is_pb_user,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_is_data_sharing END AS fbg_is_data_sharing,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_kyc_completed_ts END AS fbg_kyc_completed_ts,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_vip_id END AS fbg_vip_id,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_vip_tiers END AS fbg_vip_tiers,
    CASE WHEN fbg_status = 'ACTIVE' THEN fbg_vip_tier_modified_ts END AS fbg_vip_tier_modified_ts
FROM base
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY private_fan_id
    ORDER BY
        CASE
            WHEN fbg_status = 'ACTIVE' THEN 1
            WHEN fbg_status = 'REQUIRES_ID_VERIFICATION' THEN 2
            WHEN fbg_status = 'UNVERIFIED' THEN 3
            ELSE 4
        END,
        fbg_last_modified_ts DESC,
        fbg_account_creation_ts DESC,
        fbg_account_id DESC
) = 1 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_accounts", "node_alias": "pfi_fbg_accounts", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_accounts.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_accounts", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "8e537add93c83378ac6f62442baa9624"} */
