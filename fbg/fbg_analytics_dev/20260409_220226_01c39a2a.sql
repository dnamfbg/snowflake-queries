-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4ebb
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:26.400000+00:00
-- Elapsed: 199ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."BET_TYPE" AS "BET_TYPE",
  "Custom SQL Query"."LEGS" AS "LEGS",
  "Custom SQL Query"."ODDS" AS "ODDS",
  "Custom SQL Query"."PLACED_TIME" AS "PLACED_TIME",
  "Custom SQL Query"."POSSIBLE_WIN" AS "POSSIBLE_WIN",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SPORT" AS "SPORT",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."VIP" AS "VIP",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  select * from final
) "Custom SQL Query"
