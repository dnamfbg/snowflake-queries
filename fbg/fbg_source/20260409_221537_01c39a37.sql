-- Query ID: 01c39a37-0212-67a9-24dd-070319416e73
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:15:37.060000+00:00
-- Elapsed: 2863ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."AMOUNT" AS "AMOUNT",
  "Custom SQL Query"."Deposit/Withdrawal_Method" AS "Deposit/Withdrawal_Method",
  "Custom SQL Query"."LATEST_TRANS_DATE" AS "LATEST_TRANS_DATE",
  "Custom SQL Query"."PAYMENT_BRAND" AS "PAYMENT_BRAND",
  "Custom SQL Query"."PAYMENT_METHOD" AS "PAYMENT_METHOD",
  "Custom SQL Query"."TRANSACTION_COUNT" AS "TRANSACTION_COUNT"
FROM (
  SELECT *
  FROM FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY
) "Custom SQL Query"
