-- Query ID: 01c39a4c-0212-6e7d-24dd-070319457b2b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:36:28.566000+00:00
-- Elapsed: 1180ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."DAY1_AWARDED_" AS "DAY1_AWARDED_",
  "Custom SQL Query"."DAY1_OPTEDIN_" AS "DAY1_OPTEDIN_",
  "Custom SQL Query"."DAY2_AWARDED_" AS "DAY2_AWARDED_",
  "Custom SQL Query"."DAY2_MISSED" AS "DAY2_MISSED",
  "Custom SQL Query"."DAY2_OPTEDIN_" AS "DAY2_OPTEDIN_",
  "Custom SQL Query"."DAY3_AWARDED_" AS "DAY3_AWARDED_",
  "Custom SQL Query"."DAY3_MISSED" AS "DAY3_MISSED",
  "Custom SQL Query"."DAY3_OPTEDIN_" AS "DAY3_OPTEDIN_",
  "Custom SQL Query"."DAY4_AWARDED_" AS "DAY4_AWARDED_",
  "Custom SQL Query"."DAY4_MISSED" AS "DAY4_MISSED",
  "Custom SQL Query"."DAY4_OPTEDIN_" AS "DAY4_OPTEDIN_",
  "Custom SQL Query"."DAY5_AWARDED_" AS "DAY5_AWARDED_",
  "Custom SQL Query"."DAY5_MISSED" AS "DAY5_MISSED",
  "Custom SQL Query"."DAY5_OPTEDIN_" AS "DAY5_OPTEDIN_",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE",
  "Custom SQL Query"."Timestamp EST of $10 Casino Cash Wagering" AS "Timestamp EST of $10 Casino Cash Wagering",
  "Custom SQL Query"."Timestamp EST of Day 1 Opted In" AS "Timestamp EST of Day 1 Opted In",
  "Custom SQL Query"."Timestamp EST of Day 1" AS "Timestamp EST of Day 1",
  "Custom SQL Query"."Timestamp EST of Day 2 Opted In" AS "Timestamp EST of Day 2 Opted In",
  "Custom SQL Query"."Timestamp EST of Day 2" AS "Timestamp EST of Day 2",
  "Custom SQL Query"."Timestamp EST of Day 3 Opted In" AS "Timestamp EST of Day 3 Opted In",
  "Custom SQL Query"."Timestamp EST of Day 3" AS "Timestamp EST of Day 3",
  "Custom SQL Query"."Timestamp EST of Day 4 Opted In" AS "Timestamp EST of Day 4 Opted In",
  "Custom SQL Query"."Timestamp EST of Day 4" AS "Timestamp EST of Day 4",
  "Custom SQL Query"."Timestamp EST of Day 5 Opted In" AS "Timestamp EST of Day 5 Opted In",
  "Custom SQL Query"."Timestamp EST of Day 5" AS "Timestamp EST of Day 5",
  "Custom SQL Query"."Timestamp EST of KYC" AS "Timestamp EST of KYC",
  "Custom SQL Query"."Timestamp EST of Opt In" AS "Timestamp EST of Opt In",
  "Custom SQL Query"."Timestamp EST of Registration" AS "Timestamp EST of Registration",
  "Custom SQL Query"."Wager Requirement T/F" AS "Wager Requirement T/F"
FROM (
  select * from fbg_analytics.casino.casino_suo_1000fs
) "Custom SQL Query"
