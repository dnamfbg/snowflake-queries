-- Query ID: 01c39a29-0212-67a9-24dd-0703193e572b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:55.808000+00:00
-- Elapsed: 3061ms
-- Environment: FBG

SELECT "Custom SQL Query"."AGENT_EMAIL" AS "AGENT_EMAIL",
  "Custom SQL Query"."AGENT_ID" AS "AGENT_ID",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TIME_MINUTES" AS "CASE_TIME_MINUTES",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG"
FROM (
  SELECT date(case_created_est) date,
  case_number,
  agent_email,
  case_type,
  case_subtype,
  case_time_minutes,
  product_flag,
  agent_id
  FROM fbg_analytics.operations.cs_cases
  WHERE 1 = 1
  
  AND date >= '2024-09-01'
  ORDER BY date desc
) "Custom SQL Query"
