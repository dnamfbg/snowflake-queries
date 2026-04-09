-- Query ID: 01c399ee-0212-6e7d-24dd-0703193024f3
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T21:02:43.541000+00:00
-- Elapsed: 199251ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."ACS_SETTLEMENT_VERSION" AS "ACS_SETTLEMENT_VERSION",
  "Custom SQL Query"."American Wager Odds" AS "American Wager Odds",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."Bettor ID" AS "Bettor ID",
  "Custom SQL Query"."Bonus Bet" AS "Bonus Bet",
  "Custom SQL Query"."Bonus Money Amount Wagered" AS "Bonus Money Amount Wagered",
  "Custom SQL Query"."Bonus Money Cancels" AS "Bonus Money Cancels",
  "Custom SQL Query"."Bonus Money Resettlements" AS "Bonus Money Resettlements",
  "Custom SQL Query"."Bonus Money Voids Excluding Fancash" AS "Bonus Money Voids Excluding Fancash",
  "Custom SQL Query"."Bonus Money Voids" AS "Bonus Money Voids",
  "Custom SQL Query"."Bonus Money Winnings" AS "Bonus Money Winnings",
  "Custom SQL Query"."Early Cashed Out Bet?" AS "Early Cashed Out Bet?",
  "Custom SQL Query"."Event ID" AS "Event ID",
  "Custom SQL Query"."Event Name" AS "Event Name",
  "Custom SQL Query"."Event Time" AS "Event Time",
  "Custom SQL Query"."Market" AS "Market",
  "Custom SQL Query"."Real Money Amount Wagered" AS "Real Money Amount Wagered",
  "Custom SQL Query"."Real Money Cancels" AS "Real Money Cancels",
  "Custom SQL Query"."Real Money Resettlements" AS "Real Money Resettlements",
  "Custom SQL Query"."Real Money Voids" AS "Real Money Voids",
  "Custom SQL Query"."Real Money Winnings" AS "Real Money Winnings",
  "Custom SQL Query"."Sport" AS "Sport",
  "Custom SQL Query"."State" AS "State",
  "Custom SQL Query"."TRANS" AS "TRANS",
  "Custom SQL Query"."Total Wager Amount by Settlement Date" AS "Total Wager Amount by Settlement Date",
  "Custom SQL Query"."Transaction Date" AS "Transaction Date",
  "Custom SQL Query"."Transaction Time" AS "Transaction Time",
  "Custom SQL Query"."Void Reason" AS "Void Reason",
  "Custom SQL Query"."Voided by ID" AS "Voided by ID",
  "Custom SQL Query"."Wager Odds" AS "Wager Odds",
  "Custom SQL Query"."Wager Selection" AS "Wager Selection",
  "Custom SQL Query"."Wager Type" AS "Wager Type"
FROM (
  select *
  from fbg_reports.regulatory.transactional_wager_report
) "Custom SQL Query"
