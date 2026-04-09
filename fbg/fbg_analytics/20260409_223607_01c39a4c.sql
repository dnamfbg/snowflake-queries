-- Query ID: 01c39a4c-0212-67a8-24dd-07031945b38f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:36:07.514000+00:00
-- Elapsed: 886ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."Casino Credit Awarded T/F" AS "Casino Credit Awarded T/F",
  "Custom SQL Query"."Fancash Awarded T/F" AS "Fancash Awarded T/F",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE",
  "Custom SQL Query"."Timestamp EST of $10 Casino Cash Wagering" AS "Timestamp EST of $10 Casino Cash Wagering",
  "Custom SQL Query"."Timestamp EST of Casino Credit Awarded" AS "Timestamp EST of Casino Credit Awarded",
  "Custom SQL Query"."Timestamp EST of Fancash Awarded" AS "Timestamp EST of Fancash Awarded",
  "Custom SQL Query"."Timestamp EST of KYC" AS "Timestamp EST of KYC",
  "Custom SQL Query"."Timestamp EST of Opt In" AS "Timestamp EST of Opt In",
  "Custom SQL Query"."Timestamp EST of Registration" AS "Timestamp EST of Registration",
  "Custom SQL Query"."Wager Requirement T/F" AS "Wager Requirement T/F"
FROM (
  select * from fbg_analytics.casino.casino_suo_130242
) "Custom SQL Query"
