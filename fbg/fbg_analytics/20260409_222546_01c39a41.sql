-- Query ID: 01c39a41-0212-6dbe-24dd-07031943953f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:25:46.275000+00:00
-- Elapsed: 72ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AMELCO_ID" AS "AMELCO_ID",
  "Custom SQL Query"."Account Manager" AS "Account Manager",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_END_DATE_ET" AS "BONUS_END_DATE_ET",
  "Custom SQL Query"."BONUS_START_DATE_ET" AS "BONUS_START_DATE_ET",
  "Custom SQL Query"."CASH_PAYOUT" AS "CASH_PAYOUT",
  "Custom SQL Query"."CASH_STAKE" AS "CASH_STAKE",
  "Custom SQL Query"."FC_ACCRUED" AS "FC_ACCRUED",
  "Custom SQL Query"."FC_THEO_ACCRUED" AS "FC_THEO_ACCRUED",
  "Custom SQL Query"."GAME_NAME" AS "GAME_NAME",
  "Custom SQL Query"."IS_TEST_ACCOUNT" AS "IS_TEST_ACCOUNT",
  "Custom SQL Query"."JURISDICTION_NAME" AS "JURISDICTION_NAME",
  "Custom SQL Query"."OPTINTIME_ET" AS "OPTINTIME_ET",
  "Custom SQL Query"."OPT_INS" AS "OPT_INS",
  "Custom SQL Query"."SLOT_CASH_PAYOUT" AS "SLOT_CASH_PAYOUT",
  "Custom SQL Query"."SLOT_CASH_STAKE" AS "SLOT_CASH_STAKE",
  "Custom SQL Query"."TABLE_CASH_PAYOUT" AS "TABLE_CASH_PAYOUT",
  "Custom SQL Query"."TABLE_CASH_STAKE" AS "TABLE_CASH_STAKE",
  "Custom SQL Query"."UPDATETIMEUTC" AS "UPDATETIMEUTC"
FROM (
  select * from fbg_analytics.casino.dummy_optin
) "Custom SQL Query"
