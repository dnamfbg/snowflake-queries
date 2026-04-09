-- Query ID: 01c39a2c-0212-6dbe-24dd-0703193f036b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:04:23.619000+00:00
-- Elapsed: 76ms
-- Environment: FBG

SELECT "Custom SQL Query1"."ACCO_ID" AS "ACCO_ID (Custom SQL Query1)",
  "Custom SQL Query1"."PRED_GP_18MO_TOTAL_FINAL" AS "PRED_GP_18MO_TOTAL_FINAL"
FROM (
  select acco_id, PRED_GP_18MO_TOTAL_FINAL from fbg_analytics.product_and_customer.acquisition_customer_mart
) "Custom SQL Query1"
