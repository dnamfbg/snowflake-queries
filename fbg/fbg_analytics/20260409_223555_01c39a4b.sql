-- Query ID: 01c39a4b-0212-67a9-24dd-070319455f6b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:35:55.685000+00:00
-- Elapsed: 1064ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."Day 1 Wager Requirement T/F" AS "Day 1 Wager Requirement T/F",
  "Custom SQL Query"."Day 2 Awarded T/F" AS "Day 2 Awarded T/F",
  "Custom SQL Query"."Day 2 OptedIn T/F" AS "Day 2 OptedIn T/F",
  "Custom SQL Query"."Day 3 Awarded T/F" AS "Day 3 Awarded T/F",
  "Custom SQL Query"."Day 3 OptedIn T/F" AS "Day 3 OptedIn T/F",
  "Custom SQL Query"."Timestamp EST of $30 Casino Cash Wagering" AS "Timestamp EST of $30 Casino Cash Wagering",
  "Custom SQL Query"."Timestamp EST of Casino First Time Cash Date" AS "Timestamp EST of Casino First Time Cash Date",
  "Custom SQL Query"."Timestamp EST of KYC" AS "Timestamp EST of KYC",
  "Custom SQL Query"."Timestamp EST of Opt In to 105973" AS "Timestamp EST of Opt In to 105973",
  "Custom SQL Query"."Timestamp EST of Opt In to 105982" AS "Timestamp EST of Opt In to 105982",
  "Custom SQL Query"."Timestamp EST of Opt In to 105983" AS "Timestamp EST of Opt In to 105983",
  "Custom SQL Query"."Timestamp EST of Registration" AS "Timestamp EST of Registration"
FROM (
  select * from fbg_analytics.casino.casino_suo_30_50_cc
) "Custom SQL Query"
