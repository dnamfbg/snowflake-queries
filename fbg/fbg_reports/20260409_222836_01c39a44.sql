-- Query ID: 01c39a44-0212-67a8-24dd-070319442887
-- Database: FBG_REPORTS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T22:28:36.148000+00:00
-- Elapsed: 138ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query3"."DETAILED_GAME_TYPE" AS "DETAILED_GAME_TYPE",
  "Custom SQL Query3"."GAME_AGGREGATOR" AS "GAME_AGGREGATOR",
  "Custom SQL Query3"."GAME_ID" AS "GAME_ID (Custom SQL Query3)",
  "Custom SQL Query3"."GAME_NAME" AS "GAME_NAME (Custom SQL Query3)",
  "Custom SQL Query3"."GAME_PROVIDER" AS "GAME_PROVIDER (Custom SQL Query3)",
  "Custom SQL Query3"."GAME_TYPE" AS "GAME_TYPE (Custom SQL Query3)",
  "Custom SQL Query3"."LIVE_DEALER" AS "LIVE_DEALER",
  "Custom SQL Query3"."MAX_BET" AS "MAX_BET",
  "Custom SQL Query3"."MIN_BET" AS "MIN_BET",
  "Custom SQL Query3"."RTP" AS "RTP (Custom SQL Query3)",
  "Custom SQL Query3"."STATUS" AS "STATUS",
  "Custom SQL Query3"."SUPPORT_FREE_SPINS" AS "SUPPORT_FREE_SPINS",
  "Custom SQL Query3"."SUPPORT_JACKPOTS" AS "SUPPORT_JACKPOTS",
  "Custom SQL Query3"."TAGLINE" AS "TAGLINE",
  "Custom SQL Query3"."W2G_TYPE" AS "W2G_TYPE"
FROM (
  select * from fbg_reports.regulatory.casino_games_table
) "Custom SQL Query3"
