-- Query ID: 01c39a4b-0212-67a9-24dd-070319455e93
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:35:42.369000+00:00
-- Elapsed: 635ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."DAY10_AWARDED" AS "DAY10_AWARDED",
  "Custom SQL Query"."DAY10_OPTEDIN" AS "DAY10_OPTEDIN",
  "Custom SQL Query"."DAY1_AWARDED" AS "DAY1_AWARDED",
  "Custom SQL Query"."DAY1_OPTEDIN" AS "DAY1_OPTEDIN",
  "Custom SQL Query"."DAY2_AWARDED" AS "DAY2_AWARDED",
  "Custom SQL Query"."DAY2_OPTEDIN" AS "DAY2_OPTEDIN",
  "Custom SQL Query"."DAY3_AWARDED" AS "DAY3_AWARDED",
  "Custom SQL Query"."DAY3_OPTEDIN" AS "DAY3_OPTEDIN",
  "Custom SQL Query"."DAY4_AWARDED" AS "DAY4_AWARDED",
  "Custom SQL Query"."DAY4_OPTEDIN" AS "DAY4_OPTEDIN",
  "Custom SQL Query"."DAY5_AWARDED" AS "DAY5_AWARDED",
  "Custom SQL Query"."DAY5_OPTEDIN" AS "DAY5_OPTEDIN",
  "Custom SQL Query"."DAY6_AWARDED" AS "DAY6_AWARDED",
  "Custom SQL Query"."DAY6_OPTEDIN" AS "DAY6_OPTEDIN",
  "Custom SQL Query"."DAY7_AWARDED" AS "DAY7_AWARDED",
  "Custom SQL Query"."DAY7_OPTEDIN" AS "DAY7_OPTEDIN",
  "Custom SQL Query"."DAY8_AWARDED" AS "DAY8_AWARDED",
  "Custom SQL Query"."DAY8_OPTEDIN" AS "DAY8_OPTEDIN",
  "Custom SQL Query"."DAY9_AWARDED" AS "DAY9_AWARDED",
  "Custom SQL Query"."DAY9_OPTEDIN" AS "DAY9_OPTEDIN",
  "Custom SQL Query"."Timestamp EST of $10 Casino Cash Wagering" AS "Timestamp EST of $10 Casino Cash Wagering",
  "Custom SQL Query"."Timestamp EST of KYC" AS "Timestamp EST of KYC",
  "Custom SQL Query"."Timestamp EST of Opt In" AS "Timestamp EST of Opt In",
  "Custom SQL Query"."Timestamp EST of Registration" AS "Timestamp EST of Registration",
  "Custom SQL Query"."Wager Requirement T/F" AS "Wager Requirement T/F"
FROM (
  select * from fbg_analytics.casino.casino_suo_500fs
) "Custom SQL Query"
