-- Query ID: 01c39a2c-0212-6dbe-24dd-0703193f031f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:04:20.853000+00:00
-- Elapsed: 698ms
-- Environment: FBG

SELECT "Custom SQL Query2"."ACCO_ID" AS "ACCO_ID (Custom SQL Query2)",
  "Custom SQL Query2"."GOLD_MODEL" AS "GOLD_MODEL",
  "Custom SQL Query2"."OC_14D" AS "OC_14D",
  "Custom SQL Query2"."OC_1D" AS "OC_1D",
  "Custom SQL Query2"."OC_30D" AS "OC_30D",
  "Custom SQL Query2"."OC_7D" AS "OC_7D",
  "Custom SQL Query2"."OSB_14D" AS "OSB_14D",
  "Custom SQL Query2"."OSB_1D" AS "OSB_1D",
  "Custom SQL Query2"."OSB_30D" AS "OSB_30D",
  "Custom SQL Query2"."OSB_7D" AS "OSB_7D",
  "Custom SQL Query2"."TOTAL_14D" AS "TOTAL_14D",
  "Custom SQL Query2"."TOTAL_1D" AS "TOTAL_1D",
  "Custom SQL Query2"."TOTAL_30D" AS "TOTAL_30D",
  "Custom SQL Query2"."TOTAL_7D" AS "TOTAL_7D",
  "Custom SQL Query2"."V1_MODEL" AS "V1_MODEL",
  "Custom SQL Query2"."V2_MODEL" AS "V2_MODEL"
FROM (
  with exploded as (
  SELECT 
    acco_id,
    TRIM(value) AS model_name
  FROM fbg_analytics.product_and_customer.fast_track_attribute,
  LATERAL FLATTEN(input => SPLIT(cleaned_trigger, ','))
  where fast_track_start_date >= '2025-11-10'
  )
  SELECT
    acco_id,
    MAX(IFF(model_name = 'OC 1D', 1, 0)) AS OC_1D,
    MAX(IFF(model_name = 'Total 1D', 1, 0)) AS Total_1D,
    MAX(IFF(model_name = 'OC 7D', 1, 0)) AS OC_7D,
    MAX(IFF(model_name = 'Total 7D', 1, 0)) AS Total_7D,
    MAX(IFF(model_name = 'OSB 7D', 1, 0)) AS OSB_7D,
    MAX(IFF(model_name = 'OSB 14D', 1, 0)) AS OSB_14D,
    MAX(IFF(model_name = 'OSB 1D', 1, 0)) AS OSB_1D,
    MAX(IFF(model_name = 'OC 14D', 1, 0)) AS OC_14D,
    MAX(IFF(model_name = 'Total 30D', 1, 0)) AS Total_30D,
    MAX(IFF(model_name = 'Total 14D', 1, 0)) AS Total_14D,
    MAX(IFF(model_name = 'OC 30D', 1, 0)) AS OC_30D,
    MAX(IFF(model_name = 'OSB 30D', 1, 0)) AS OSB_30D,
    MAX(IFF(model_name = 'Gold Inference Model', 1, 0)) AS gold_model,
    MAX(IFF(model_name = 'VIP Model V1', 1, 0)) AS v1_model,
    MAX(IFF(model_name = 'VIP Model V2', 1, 0)) AS v2_model
  FROM exploded
  GROUP BY acco_id
) "Custom SQL Query2"
