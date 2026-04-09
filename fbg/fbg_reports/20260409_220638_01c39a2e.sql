-- Query ID: 01c39a2e-0212-67a9-24dd-0703193f45ef
-- Database: FBG_REPORTS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:06:38.866000+00:00
-- Elapsed: 47ms
-- Environment: FBG

SELECT "Custom SQL Query4"."ACCO_ID" AS "ACCO_ID (Custom SQL Query4)",
  "Custom SQL Query4"."AMOUNT" AS "AMOUNT (Custom SQL Query4)",
  "Custom SQL Query4"."DEPOSIT_WITHDRAWAL_METRIC_NAME" AS "DEPOSIT_WITHDRAWAL_METRIC_NAME (Custom SQL Query4)",
  "Custom SQL Query4"."GAMING_DATE_ALK" AS "GAMING_DATE_ALK (Custom SQL Query4)",
  "Custom SQL Query4"."IS_TEST_ACCOUNT" AS "IS_TEST_ACCOUNT",
  "Custom SQL Query4"."JURISDICTION_FULLNAME" AS "JURISDICTION_FULLNAME (Custom SQL Query4)",
  "Custom SQL Query4"."PAYMENT_BRAND" AS "PAYMENT_BRAND (Custom SQL Query4)",
  "Custom SQL Query4"."SOURCE" AS "SOURCE (Custom SQL Query4)",
  "Custom SQL Query4"."TIMESTAMP_ALK" AS "TIMESTAMP_ALK (Custom SQL Query4)",
  "Custom SQL Query4"."TRANS_REF" AS "TRANS_REF (Custom SQL Query4)"
FROM (
  select * from fbg_reports.regulatory.deposit_withdrawal_transactions
) "Custom SQL Query4"
