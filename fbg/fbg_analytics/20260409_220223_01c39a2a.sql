-- Query ID: 01c39a2a-0212-67a8-24dd-0703193e3b33
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:23.520000+00:00
-- Elapsed: 293ms
-- Environment: FBG

SELECT "Custom SQL Query3"."ACCO_ID" AS "ACCO_ID (Custom SQL Query3)",
  "Custom SQL Query3"."MODEL_NAME" AS "MODEL_NAME"
FROM (
  SELECT 
    acco_id,
    TRIM(value) AS model_name
  FROM fbg_analytics.product_and_customer.fast_track_attribute,
  LATERAL FLATTEN(input => SPLIT(cleaned_trigger, ','))
  where fast_track_start_date >= '2025-11-10'
) "Custom SQL Query3"
