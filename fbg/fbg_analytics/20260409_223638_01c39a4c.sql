-- Query ID: 01c39a4c-0212-6cb9-24dd-07031946009f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:36:38.389000+00:00
-- Elapsed: 50549ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."Bonus Opt In" AS "Bonus Opt In",
  "Custom SQL Query"."DAY10_AWARDED" AS "DAY10_AWARDED",
  "Custom SQL Query"."DAY10_AWARDED_DATE" AS "DAY10_AWARDED_DATE",
  "Custom SQL Query"."DAY10_OPTEDIN" AS "DAY10_OPTEDIN",
  "Custom SQL Query"."DAY10_OPTIN_DATE" AS "DAY10_OPTIN_DATE",
  "Custom SQL Query"."DAY1_AWARDED" AS "DAY1_AWARDED",
  "Custom SQL Query"."DAY1_AWARDED_DATE" AS "DAY1_AWARDED_DATE",
  "Custom SQL Query"."DAY1_OPTEDIN" AS "DAY1_OPTEDIN",
  "Custom SQL Query"."DAY1_OPTIN_DATE" AS "DAY1_OPTIN_DATE",
  "Custom SQL Query"."DAY2_AWARDED" AS "DAY2_AWARDED",
  "Custom SQL Query"."DAY2_AWARDED_DATE" AS "DAY2_AWARDED_DATE",
  "Custom SQL Query"."DAY2_OPTEDIN" AS "DAY2_OPTEDIN",
  "Custom SQL Query"."DAY2_OPTIN_DATE" AS "DAY2_OPTIN_DATE",
  "Custom SQL Query"."DAY3_AWARDED" AS "DAY3_AWARDED",
  "Custom SQL Query"."DAY3_AWARDED_DATE" AS "DAY3_AWARDED_DATE",
  "Custom SQL Query"."DAY3_OPTEDIN" AS "DAY3_OPTEDIN",
  "Custom SQL Query"."DAY3_OPTIN_DATE" AS "DAY3_OPTIN_DATE",
  "Custom SQL Query"."DAY4_AWARDED" AS "DAY4_AWARDED",
  "Custom SQL Query"."DAY4_AWARDED_DATE" AS "DAY4_AWARDED_DATE",
  "Custom SQL Query"."DAY4_OPTEDIN" AS "DAY4_OPTEDIN",
  "Custom SQL Query"."DAY4_OPTIN_DATE" AS "DAY4_OPTIN_DATE",
  "Custom SQL Query"."DAY5_AWARDED" AS "DAY5_AWARDED",
  "Custom SQL Query"."DAY5_AWARDED_DATE" AS "DAY5_AWARDED_DATE",
  "Custom SQL Query"."DAY5_OPTEDIN" AS "DAY5_OPTEDIN",
  "Custom SQL Query"."DAY5_OPTIN_DATE" AS "DAY5_OPTIN_DATE",
  "Custom SQL Query"."DAY6_AWARDED" AS "DAY6_AWARDED",
  "Custom SQL Query"."DAY6_AWARDED_DATE" AS "DAY6_AWARDED_DATE",
  "Custom SQL Query"."DAY6_OPTEDIN" AS "DAY6_OPTEDIN",
  "Custom SQL Query"."DAY6_OPTIN_DATE" AS "DAY6_OPTIN_DATE",
  "Custom SQL Query"."DAY7_AWARDED" AS "DAY7_AWARDED",
  "Custom SQL Query"."DAY7_AWARDED_DATE" AS "DAY7_AWARDED_DATE",
  "Custom SQL Query"."DAY7_OPTEDIN" AS "DAY7_OPTEDIN",
  "Custom SQL Query"."DAY7_OPTIN_DATE" AS "DAY7_OPTIN_DATE",
  "Custom SQL Query"."DAY8_AWARDED" AS "DAY8_AWARDED",
  "Custom SQL Query"."DAY8_AWARDED_DATE" AS "DAY8_AWARDED_DATE",
  "Custom SQL Query"."DAY8_OPTEDIN" AS "DAY8_OPTEDIN",
  "Custom SQL Query"."DAY8_OPTIN_DATE" AS "DAY8_OPTIN_DATE",
  "Custom SQL Query"."DAY9_AWARDED" AS "DAY9_AWARDED",
  "Custom SQL Query"."DAY9_AWARDED_DATE" AS "DAY9_AWARDED_DATE",
  "Custom SQL Query"."DAY9_OPTEDIN" AS "DAY9_OPTEDIN",
  "Custom SQL Query"."DAY9_OPTIN_DATE" AS "DAY9_OPTIN_DATE",
  "Custom SQL Query"."KYC Completed" AS "KYC Completed",
  "Custom SQL Query"."Registration" AS "Registration",
  "Custom SQL Query"."Wager Requirement Date" AS "Wager Requirement Date",
  "Custom SQL Query"."Wager Requirement" AS "Wager Requirement"
FROM (
  select * from
  fbg_analytics.operations.cas_suo_1000fs_triple_cash_eruption
) "Custom SQL Query"
