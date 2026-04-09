-- Query ID: 01c39a33-0212-6dbe-24dd-07031940c8d7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:59.186000+00:00
-- Elapsed: 209859ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts
    
    
    
    as (WITH accounts AS ( --noqa: disable=all
    SELECT
        id::varchar AS acco_id,
        creation_date AS registration_date_utc,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', creation_date)::timestamp_ntz AS registration_date_alk,
        CONVERT_TIMEZONE('UTC', 'America/New_York', creation_date)::timestamp_ntz AS registration_date_est,
        reg_jurisdictions_id,
        COALESCE(test::number, 0)::number AS is_test_account,
        TRY_PARSE_JSON(kyc_info):KycInfo:firstName::varchar AS first_name,
        TRY_PARSE_JSON(kyc_info):KycInfo:surname::varchar AS last_name,
        TRY_PARSE_JSON(kyc_info):KycInfo:dob::date AS date_of_birth,
        TRY_PARSE_JSON(kyc_info):KycInfo:ssnLast4Digits::varchar AS ssn_last_4_digits,
        TRY_PARSE_JSON(contact_details):ContactDetail:address1::varchar AS address1,
        TRY_PARSE_JSON(contact_details):ContactDetail:address2::varchar AS address2,
        TRY_PARSE_JSON(contact_details):ContactDetail:address3::varchar AS city,
        TRY_PARSE_JSON(contact_details):ContactDetail:address4::varchar AS state,
        TRY_PARSE_JSON(contact_details):ContactDetail:postCode::varchar AS post_code,
        TRY_PARSE_JSON(contact_details):ContactDetail:country::varchar AS country,
        email
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS
    WHERE
        COALESCE(is_deleted, 0) = 0
        AND creation_date IS NOT NULL
),

first_fmx_segment AS (
    SELECT
        acco_id,
        created_at_utc AS fmx_registration_date_utc,
        created_at_alk AS fmx_registration_date_alk
    FROM (
        SELECT
            acco_id,
            created_at_utc,
            created_at_alk,
            ROW_NUMBER() OVER (PARTITION BY acco_id ORDER BY created_at_utc) AS seg_rank
        FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_account_segments
        WHERE enterprise_product = 'FMX'
    )
    WHERE seg_rank = 1
),

first_fbg_segment AS (
    SELECT
        acco_id,
        created_at_utc AS fbg_registration_date_utc,
        created_at_alk AS fbg_registration_date_alk
    FROM (
        SELECT
            acco_id,
            created_at_utc,
            created_at_alk,
            ROW_NUMBER() OVER (PARTITION BY acco_id ORDER BY created_at_utc) AS seg_rank
        FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_account_segments
        WHERE enterprise_product = 'FBG'
    )
    WHERE seg_rank = 1
)

SELECT
    a.acco_id,
    a.reg_jurisdictions_id,
    a.is_test_account,
    COALESCE(j.jurisdiction_code, 'UNKNOWN') AS registration_state,
    COALESCE(fmx.fmx_registration_date_utc, a.registration_date_utc) AS registration_date_utc,
    COALESCE(fmx.fmx_registration_date_alk, a.registration_date_alk) AS registration_date_alk,
    COALESCE(
        CONVERT_TIMEZONE('UTC', 'America/New_York', fmx.fmx_registration_date_utc),
        a.registration_date_est
    ) AS registration_date_est,
    IFF(fmx.fmx_registration_date_utc IS NOT NULL, TRUE, FALSE) AS has_registered_fmx,
    IFF(first_fbg_segment.fbg_registration_date_utc IS NOT NULL, TRUE, FALSE) AS has_registered_fbg,
    a.first_name,
    a.last_name,
    a.date_of_birth,
    a.ssn_last_4_digits,
    a.address1,
    a.address2,
    a.city,
    a.state AS kyc_state,
    a.post_code,
    a.country,
    a.email
FROM accounts AS a
LEFT JOIN first_fmx_segment AS fmx
    ON a.acco_id = fmx.acco_id
LEFT JOIN first_fbg_segment AS first_fbg_segment
    ON a.acco_id = first_fbg_segment.acco_id
LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions AS j
    ON a.reg_jurisdictions_id = j.jurisdiction_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.dim_fmx_accounts", "profile_name": "user", "target_name": "default"} */
