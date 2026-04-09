-- Query ID: 01c39a3d-0212-6e7d-24dd-07031942e1ab
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:21:32.699000+00:00
-- Elapsed: 629ms
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
  select a.* from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_10k as a
  left join FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS as b
  on a.acco_id = b.acco_id
  where (b.high_level_segment <> 'Super VIP' or b.high_level_segment is null)
) "Custom SQL Query"
