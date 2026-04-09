-- Query ID: 01c399ee-0212-6cb9-24dd-0703192ff227
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T21:02:09.672000+00:00
-- Elapsed: 510023ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."# of Tickets Written" AS "# of Tickets Written",
  "Custom SQL Query"."Accrual Basis Ticket Write" AS "Accrual Basis Ticket Write",
  "Custom SQL Query"."Accrual Win (loss)" AS "Accrual Win (loss)",
  "Custom SQL Query"."Daily Ticket Write" AS "Daily Ticket Write",
  "Custom SQL Query"."Federal Excise" AS "Federal Excise",
  "Custom SQL Query"."Gaming Date" AS "Gaming Date",
  "Custom SQL Query"."Gross Cash Payout" AS "Gross Cash Payout",
  "Custom SQL Query"."Hold %" AS "Hold %",
  "Custom SQL Query"."Previous Days' Futures Settled - Cancels and Voids" AS "Previous Days' Futures Settled - Cancels and Voids",
  "Custom SQL Query"."Previous Days' Futures Settled" AS "Previous Days' Futures Settled",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."Taxable GGR" AS "Taxable GGR",
  "Custom SQL Query"."Taxes Payable" AS "Taxes Payable",
  "Custom SQL Query"."Unsettled Future Write" AS "Unsettled Future Write"
FROM (
  select * from fbg_reports.regulatory.ma_osb_external_revenue
) "Custom SQL Query"
