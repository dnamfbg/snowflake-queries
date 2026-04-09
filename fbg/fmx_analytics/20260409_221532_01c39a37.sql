-- Query ID: 01c39a37-0212-6cb9-24dd-0703194195a7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:15:32.589000+00:00
-- Elapsed: 186388ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fmx_xtremepush_attributes
    
    
    
    as (WITH fmx_users AS ( --noqa: disable=all

    SELECT DISTINCT acco_id
    FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts
    WHERE has_registered_fmx = TRUE

),

user_profiles as(
SELECT
  a.ID "ACCOUNT_ID",
  a.status AS "ACCOUNT_STATUS",
  acr.age AS "AGE",
  ut.email AS "EMAIL",
  COALESCE(pii.city, ut.city) AS "CITY",
  j.jurisdiction_name AS "CURRENT_JURISDICTION_NAME",
  a.current_jurisdictions_id AS "CURRENT_JURISDICTION_ID",
  asl.daily_deposit_limit AS "DAILY_DEPOSIT_LIMITS",
  acr.daily_rewards_custom_field_6 AS "ACCOUNT_BALANCE",
  asl.daily_session_limit_minutes AS "DAILY_SESSION_LIMIT_MINUTES",
  ut.date_of_birth AS "DATE_OF_BIRTH",
  acr.days_since_kyc AS "DAYS_SINCE_KYC",
  a.email_confirmation_status AS "EMAIL_CONFIRMATION_STATUS",
  COALESCE(lower(ut.email) LIKE '%betfanatics%', FALSE) AS "EMAIL_IS_BETFANATICS",
  IFNULL(acr.fancash_balance, 0.0) AS "FANCASH_BALANCE",
  acr.first_deposit_date AS "FIRST_DEPOSIT_DATE",
  ut.first_name AS "FIRST_NAME",
  ut.first_product AS "FIRST_PRODUCT",
  a.STATUS IN ('ACTIVE', 'UNVERIFIED') AND (vb.ACCO_ID IS NOT NULL OR DATE(a.LAST_LOGIN_TIME) >= CURRENT_DATE() - 90) "IS_ACTIVE",
  COALESCE(pii.is_cvip, ut.is_casino_vip) AS "IS_CVIP",
  ut.kyc_date_alk AS "KYC_DATE",
  ut.kyc_date_utc AS "KYC_DATE_UTC",
  kyc_outreach_eligible AS "KYC_OUTREACH_ELIGIBLE",
  ut.last_name AS "LAST_NAME",
  acr.attribute_loyalty_last_update_et as "LATEST_UPDATE",
  asl.monthly_deposit_limit AS "MONTHLY_DEPOSIT_LIMIT",
  cas.most_recent_platform as "MOST_RECENT_PLATFORM",
  pii.postcode AS "POSTCODE",
  acr.reg_date AS "REG_DATE", 
  IFNULL(pii.reg_state, 'None') AS "REG_STATE",
  IFNULL(a.reg_jurisdictions_id, 0) AS "REGISTRATION_JURISDICTION_ID",
  cas.registration_platform as "REGISTRATION_PLATFORM",
  a.registration_status AS "REGISTRATION_STATUS",
  IFNULL(vb.SPORT_PREF, 'None') "SPORT_PREF",
  pii.state AS "STATE",
  a.test AS "TEST_ACCOUNT",
  cas.product_preference as "PRODUCT_PREFERENCE", -- Acknowledge this will not say FMX
 asl.weekly_deposit_limit AS "WEEKLY_DEPOSIT_LIMIT", 
  acr.points_tier as "POINTS_TIER",
  acr.loyalty_tier as "LOYALTY_TIER",
  acr.current_loyalty_tier_threshold as "CURRENT_LOYALTY_TIER_THRESHOLD",
  acr.next_loyalty_tier_threshold as "NEXT_LOYALTY_TIER_THRESHOLD",
  acr.points_to_next_loyalty_tier as "POINTS_TO_NEXT_LOYALTY_TIER",
  is_currently_status_match AS "IS_CURRENTLY_STATUS_MATCH",
  status_match_challenge_complete AS "STATUS_MATCH_CHALLENGE_COMPLETE",
  status_match_challenge_complete_date AS "STATUS_MATCH_CHALLENGE_COMPLETE_DATE",
  sm.status_match_end_date AS "STATUS_MATCH_END_DATE",
  status_match_loyalty_tier AS "STATUS_MATCH_LOYALTY_TIER",
  sm.status_match_start_date AS "STATUS_MATCH_START_DATE",
  sm.status_match_tier_points AS "STATUS_MATCH_TIER_POINTS",
FROM
  FBG_SOURCE.OSB_SOURCE.ACCOUNTS a
INNER JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j
    ON (a.current_jurisdictions_id = j.id)
LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS vb
    ON vb.ACCO_ID = a.ID
INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART ut
    ON ut.acco_id = a.ID
LEFT JOIN FBG_ANALYTICS.CASINO.CRM_CASINO_MODEL cas
    ON cas.ACCO_ID = a.ID
LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SPORTSBOOK_CRM_ATTRIBUTES acr
  ON a.ID = acr.acco_ID
LEFT JOIN FBG_ANALYTICS.MARKETING.ACCOUNT_SELF_LIMITS asl
  ON a.ID = asl.ACCO_ID
INNER JOIN FBG_ANALYTICS.MARKETING.COMPLIANCE_PII_TRAITS pii
  ON a.ID = pii.ACCO_ID
LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART cm
  ON a.ID = cm.ACCO_ID and a.TEST = 0
LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.STATUS_MATCH sm
    ON sm.acco_id = a.ID
)
      
      
SELECT * EXCLUDE ACCO_ID 
    FROM user_profiles
INNER JOIN fmx_users 
    ON fmx_users.acco_id = user_profiles.account_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fmx_xtremepush_attributes", "profile_name": "user", "target_name": "default"} */
