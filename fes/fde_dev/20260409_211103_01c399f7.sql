-- Query ID: 01c399f7-0112-6029-0000-e307218aeafa
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:11:03.205000+00:00
-- Elapsed: 30405ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_customer_mart (
            "PRIVATE_FAN_ID", "LOYALTY_ACCOUNT_ID", "FAN_ID_CREATION_TIME_UTC", "LOYALTY_MD5_HASHED_EMAIL", "LOYALTY_EMAIL", "FINAL_EMAIL", "PFI_USER_PROFILE_EMAIL", "FAN_KEY", "UNSCRUBBED_EMAIL", "FANKEY_MD5_HASHED_EMAIL", "TLC_TENANT_FAN_ID", "TLC_FIRST_LOGIN_DATE_UTC", "FBG_TENANT_FAN_ID", "FBG_FIRST_LOGIN_DATE_UTC", "FBG_ACCO_ID", "FBG_ACCOUNT_STATUS", "IS_FBG_DELETED", "PHONE_NUMBER", "ADDRESS_LINE_1", "ADDRESS_LINE_2", "CITY", "STATE", "ZIP_CODE", "COUNTRY", "COUNTRY_CODE", "FBG_EMAIL", "VIP", "TEST", "DELETED", "SHOP_TENANT_FAN_ID", "SHOP_FIRST_LOGIN_DATE_UTC", "POINTSVILLE_TENANT_FAN_ID", "POINTSVILLE_FIRST_LOGIN_DATE_UTC", "FANAPP_TENANT_FAN_ID", "FANAPP_FIRST_LOGIN_DATE_UTC", "LIDS_TENANT_FAN_ID", "LIDS_FIRST_LOGIN_DATE_UTC", "EVENTS_TENANT_FAN_ID", "EVENTS_FIRST_LOGIN_DATE_UTC", "TICKETMASTER_TENANT_FAN_ID", "TICKETMASTER_FIRST_LOGIN_DATE_UTC", "COMMERCE_TENANT_FAN_ID", "COMMERCE_FIRST_LOGIN_DATE_UTC", "FBG_FTU_TS_UTC", "FBG_REG_TS_UTC", "LIVE_FIRST_ORDER_TS_UTC", "COLLECT_FIRST_ORDER_TS_UTC", "TOPPS_FIRST_ORDER_TS_UTC", "TLC_FIRST_ORDER_TS_UTC", "COMMERCE_FIRST_ORDER_TS_UTC", "TICKET_FIRST_ORDER_TS_UTC", "FTP_FIRST_GAME_TS_UTC"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."LOYALTY_ACCOUNT_ID", 
            
              __src."FAN_ID_CREATION_TIME_UTC", 
            
              __src."LOYALTY_MD5_HASHED_EMAIL", 
            
              __src."LOYALTY_EMAIL", 
            
              __src."FINAL_EMAIL", 
            
              __src."PFI_USER_PROFILE_EMAIL", 
            
              __src."FAN_KEY", 
            
              __src."UNSCRUBBED_EMAIL", 
            
              __src."FANKEY_MD5_HASHED_EMAIL", 
            
              __src."TLC_TENANT_FAN_ID", 
            
              __src."TLC_FIRST_LOGIN_DATE_UTC", 
            
              __src."FBG_TENANT_FAN_ID", 
            
              __src."FBG_FIRST_LOGIN_DATE_UTC", 
            
              __src."FBG_ACCO_ID", 
            
              __src."FBG_ACCOUNT_STATUS", 
            
              __src."IS_FBG_DELETED", 
            
              __src."PHONE_NUMBER", 
            
              __src."ADDRESS_LINE_1", 
            
              __src."ADDRESS_LINE_2", 
            
              __src."CITY", 
            
              __src."STATE", 
            
              __src."ZIP_CODE", 
            
              __src."COUNTRY", 
            
              __src."COUNTRY_CODE", 
            
              __src."FBG_EMAIL", 
            
              __src."VIP", 
            
              __src."TEST", 
            
              __src."DELETED", 
            
              __src."SHOP_TENANT_FAN_ID", 
            
              __src."SHOP_FIRST_LOGIN_DATE_UTC", 
            
              __src."POINTSVILLE_TENANT_FAN_ID", 
            
              __src."POINTSVILLE_FIRST_LOGIN_DATE_UTC", 
            
              __src."FANAPP_TENANT_FAN_ID", 
            
              __src."FANAPP_FIRST_LOGIN_DATE_UTC", 
            
              __src."LIDS_TENANT_FAN_ID", 
            
              __src."LIDS_FIRST_LOGIN_DATE_UTC", 
            
              __src."EVENTS_TENANT_FAN_ID", 
            
              __src."EVENTS_FIRST_LOGIN_DATE_UTC", 
            
              __src."TICKETMASTER_TENANT_FAN_ID", 
            
              __src."TICKETMASTER_FIRST_LOGIN_DATE_UTC", 
            
              __src."COMMERCE_TENANT_FAN_ID", 
            
              __src."COMMERCE_FIRST_LOGIN_DATE_UTC", 
            
              __src."FBG_FTU_TS_UTC", 
            
              __src."FBG_REG_TS_UTC", 
            
              __src."LIVE_FIRST_ORDER_TS_UTC", 
            
              __src."COLLECT_FIRST_ORDER_TS_UTC", 
            
              __src."TOPPS_FIRST_ORDER_TS_UTC", 
            
              __src."TLC_FIRST_ORDER_TS_UTC", 
            
              __src."COMMERCE_FIRST_ORDER_TS_UTC", 
            
              __src."TICKET_FIRST_ORDER_TS_UTC", 
            
              __src."FTP_FIRST_GAME_TS_UTC"
            
          from ( WITH
tenant_map AS (
    SELECT * FROM fangraph_dev.private_fan_id.pfi_tenant_id_mapping
),

ftu_dates AS (
    SELECT * FROM fangraph_dev.private_fan_id.pfi_ftu_dates
),

fbg_account_ids AS (
    SELECT
        id AS fbg_acco_id,
        LTRIM(ref1, 'AMELCO-') AS tenant_fan_id,
        balance,
        dob,
        STATUS AS fbg_account_status,
        fbg_ftu_date,
        fbg_ftb_date,
        vip,
        test,
        deleted,
        email,
        TRY_PARSE_JSON(contact_details):ContactDetail.phone1::STRING AS phone_number,
        TRY_PARSE_JSON(contact_details):ContactDetail.address1::STRING AS address_line_1,
        TRY_PARSE_JSON(contact_details):ContactDetail.address2::STRING AS address_line_2,
        TRY_PARSE_JSON(contact_details):ContactDetail.address3::STRING AS city,
        TRY_PARSE_JSON(contact_details):ContactDetail.address4::STRING AS state,
        TRY_PARSE_JSON(contact_details):ContactDetail.postCode::STRING AS zip_code,
        TRY_PARSE_JSON(contact_details):ContactDetail.country::STRING AS country,
        TRY_PARSE_JSON(contact_details):ContactDetail.countryCode::STRING AS country_code,
        NOT COALESCE(deleted = 0, FALSE) AS is_fbg_deleted
    FROM fbg_fde.fbg_users.fbg_to_fde_accounts
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY tenant_fan_id
        ORDER BY
            is_fbg_deleted ASC,
            dw_last_updated DESC
    ) = 1
)

SELECT
    -- Identity
    t.private_fan_id,
    t.loyalty_account_id,
    t.fan_id_creation_time::TIMESTAMP_NTZ AS fan_id_creation_time_utc,
    t.loyalty_md5_hashed_email,
    t.loyalty_email,

    ---Final Email
    COALESCE(p.pfi_email, e.email, t.unscrubbed_email) AS final_email,

    ---PFI User profile
    p.pfi_email AS pfi_user_profile_email,

    -- Fan key + email
    t.fan_key,
    t.unscrubbed_email,
    t.fankey_md5_hashed_email,

    -- TLC
    t.tlc_tenant_fan_id,
    t.tlc_first_login_date_utc,

    -- FBG tenant
    t.fbg_tenant_fan_id,
    t.fbg_first_login_date_utc,

    -- FBG account details
    e.fbg_acco_id,
    e.fbg_account_status,
    e.is_fbg_deleted,
    e.phone_number,
    e.address_line_1,
    e.address_line_2,
    e.city,
    e.state,
    e.zip_code,
    e.country,
    e.country_code,
    e.email AS fbg_email,
    e.vip,
    e.test,
    e.deleted,

    -- Shop
    t.shop_tenant_fan_id,
    t.shop_first_login_date_utc,

    -- Pointsville
    t.pointsville_tenant_fan_id,
    t.pointsville_first_login_date_utc,

    -- FanApp
    t.fanapp_tenant_fan_id,
    t.fanapp_first_login_date_utc,

    -- Lids
    t.lids_tenant_fan_id,
    t.lids_first_login_date_utc,

    -- Events
    t.events_tenant_fan_id,
    t.events_first_login_date_utc,

    -- Ticketmaster
    t.ticketmaster_tenant_fan_id,
    t.ticketmaster_first_login_date_utc,

    -- Commerce
    t.commerce_tenant_fan_id,
    t.commerce_first_login_date_utc,

    -- FTU dates
    f.fbg_ftu_ts_utc,
    f.fbg_reg_ts_utc,
    f.live_first_order_ts_utc,
    f.collect_first_order_ts_utc,
    f.topps_first_order_ts_utc,
    f.tlc_first_order_ts_utc,
    f.commerce_first_order_ts_utc,
    f.ticket_first_order_ts_utc,
    f.ftp_first_game_ts_utc

FROM tenant_map AS t
LEFT JOIN ftu_dates AS f ON t.private_fan_id = f.private_fan_id
LEFT JOIN fbg_account_ids AS e ON t.fbg_tenant_fan_id = e.tenant_fan_id
LEFT JOIN fangraph_dev.private_fan_id.pfi_user_profile AS p ON t.private_fan_id = p.private_fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_customer_mart", "node_alias": "pfi_customer_mart", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_customer_mart.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_customer_mart", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_tenant_id_mapping", "pfi_ftu_dates", "pfi_user_profile"], "materialized": "table", "raw_code_hash": "5cf5cff4d281e709e1b841826b5cafa2"} */
