-- Query ID: 01c39a29-0212-67a9-24dd-0703193e524b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:17.238000+00:00
-- Elapsed: 8150ms
-- Environment: FBG

SELECT TRY_CAST("Custom SQL Query"."CASE_NUMBER" AS INT) AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CASE_WORKED" AS "CASE_WORKED",
  "Custom SQL Query"."CS_ESCALATED" AS "CS_ESCALATED",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."ESCALATOR" AS "ESCALATOR",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG"
FROM (
  WITH escalations AS (
    SELECT *
    FROM fbg_analytics.operations.escalation_rate
  ),
  case_data AS (
    SELECT *
    FROM fbg_analytics.operations.cs_cases 
  )
  
  SELECT  
    DATE(cd.case_created_est) AS date,
    cd.case_number,
    cd.case_type,
    cd.case_subtype,
    cd.product_flag,
    cd.agent_id as escalator,
    e.is_escalated AS cs_escalated,
    1 as case_worked
  FROM escalations e
  LEFT JOIN case_data cd ON e.case_number = cd.case_number
  WHERE 
   DATE(cd.case_created_est) >= '2024-09-01'
) "Custom SQL Query"
