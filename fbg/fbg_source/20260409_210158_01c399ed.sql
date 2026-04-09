-- Query ID: 01c399ed-0212-6cb9-24dd-0703192ff0e7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T21:01:58.180000+00:00
-- Elapsed: 174ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."Gaming Date" AS "Gaming Date",
  "Custom SQL Query"."Total Cash Winnings Payout" AS "Total Cash Winnings Payout",
  "Custom SQL Query"."Total Gross Wagers Placed" AS "Total Gross Wagers Placed",
  "Custom SQL Query"."Total Non-Cash Wagers Placed" AS "Total Non-Cash Wagers Placed",
  "Custom SQL Query"."Total Voided Bets" AS "Total Voided Bets"
FROM (
  select *
  from fbg_reports.regulatory.oh_osb_transactional_daily_revenue
) "Custom SQL Query"
