-- Query ID: 01c399ed-0212-6cb9-24dd-0703192f8e4b
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:01:39.642000+00:00
-- Elapsed: 93ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCT_ID" AS "ACCT_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."Bet Type Level 1" AS "Bet Type Level 1",
  "Custom SQL Query"."Bet Type Level 2" AS "Bet Type Level 2",
  "Custom SQL Query"."CHANNEL" AS "CHANNEL",
  "Custom SQL Query"."COMP" AS "COMP",
  "Custom SQL Query"."COUNTRY" AS "COUNTRY",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."Event Time" AS "Event Time",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."JURISDICTION_CODE" AS "JURISDICTION_CODE",
  "Custom SQL Query"."LIVE_BET" AS "LIVE_BET",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."MRKT_TYPE" AS "MRKT_TYPE",
  "Custom SQL Query"."NODE_ID" AS "NODE_ID"
FROM (
  select * 
  from fbg_reports.finance.nfl_bet_data
) "Custom SQL Query"
