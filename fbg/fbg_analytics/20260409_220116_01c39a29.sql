-- Query ID: 01c39a29-0212-6dbe-24dd-0703193e2453
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:16.695000+00:00
-- Elapsed: 3702ms
-- Environment: FBG

SELECT "Custom SQL Query"."AGENT_EMAIL" AS "AGENT_EMAIL",
  "Custom SQL Query"."AGENT_ID" AS "AGENT_ID",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SOURCE" AS "CASE_SOURCE",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CURRENT_CASINO_SEGMENT" AS "CURRENT_CASINO_SEGMENT",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."FCR1" AS "FCR1",
  "Custom SQL Query"."FCR24" AS "FCR24",
  "Custom SQL Query"."FCR2" AS "FCR2",
  "Custom SQL Query"."FCR48" AS "FCR48",
  "Custom SQL Query"."FCR8" AS "FCR8",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG"
FROM (
  SELECT 
      TO_DATE(c.case_created_est) AS date,
      c.agent_email,
      c.agent_id,
      c.case_number,
      c.product_flag,
      c.case_type,
      c.case_subtype,
      c.current_state,
      c.current_value_band,
      c.current_casino_segment,
      c.case_source,
      f.first_contact_resolved_1hr as fcr1,
      f.first_contact_resolved_2hr as fcr2,
      f.first_contact_resolved_8hr as fcr8,
      f.first_contact_resolved_24hr as fcr24,
      f.first_contact_resolved_48hr as fcr48
  
  FROM fbg_analytics.operations.first_contact_resolution f
  left join fbg_analytics.operations.cs_cases c on f.case_number = c.case_number
  WHERE 
      1=1
      AND c.agent_name NOT IN ('Platform Integration User', 'Data Team Integration')
      AND c.agent_company NOT IN ('KMC', 'Korn Ferry')
      AND c.case_status not IN ('Merged')
      and c.case_type NOT IN ('PointsBet', 'Routing')
      AND TO_DATE(c.case_created_est) <> CURRENT_DATE
      AND c.case_created_est >= '2024-09-01'
  GROUP BY ALL
  ORDER BY date DESC
) "Custom SQL Query"
