-- Query ID: 01c39a29-0212-644a-24dd-0703193e0e23
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:01:20.575000+00:00
-- Elapsed: 3044ms
-- Environment: FBG

SELECT "Custom SQL Query"."AGENT_EMAIL" AS "AGENT_EMAIL",
  "Custom SQL Query"."AGENT_ID" AS "AGENT_ID",
  "Custom SQL Query"."AGENT_NAME" AS "AGENT_NAME",
  "Custom SQL Query"."AGENT_TYPE" AS "AGENT_TYPE",
  "Custom SQL Query"."CASES" AS "CASES",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SOURCE" AS "CASE_SOURCE",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CLOSED_DATE" AS "CLOSED_DATE",
  "Custom SQL Query"."CREATED_DATE" AS "CREATED_DATE",
  "Custom SQL Query"."CSAT_SCORE" AS "CSAT_SCORE",
  "Custom SQL Query"."CURRENT_CASINO_SEGMENT" AS "CURRENT_CASINO_SEGMENT",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."DAYS_OFF" AS "DAYS_OFF",
  "Custom SQL Query"."DW_LAST_UPDATED" AS "DW_LAST_UPDATED",
  "Custom SQL Query"."EMAIL" AS "EMAIL",
  "Custom SQL Query"."FANAPP" AS "FANAPP",
  "Custom SQL Query"."FTE_SEASONAL" AS "FTE_SEASONAL",
  "Custom SQL Query"."HOME_LOCATION" AS "HOME_LOCATION",
  "Custom SQL Query"."IL_LICENSE" AS "IL_LICENSE",
  "Custom SQL Query"."IN_LICENSE" AS "IN_LICENSE",
  "Custom SQL Query"."LEAVE_END_DATE" AS "LEAVE_END_DATE",
  "Custom SQL Query"."NJ_LICENSE" AS "NJ_LICENSE",
  "Custom SQL Query"."PA_LICENCE" AS "PA_LICENCE",
  "Custom SQL Query"."REMOTE" AS "REMOTE",
  "Custom SQL Query"."REPORTS_TO" AS "REPORTS_TO",
  "Custom SQL Query"."SALESFORCE_ID" AS "SALESFORCE_ID",
  "Custom SQL Query"."SF_ALIAS" AS "SF_ALIAS",
  "Custom SQL Query"."SHIFT_(EST)" AS "SHIFT_(EST)",
  "Custom SQL Query"."START_DATE" AS "START_DATE",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."TERM_DATE" AS "TERM_DATE",
  "Custom SQL Query"."TITLE" AS "TITLE",
  "Custom SQL Query"."VIP_SKILLED" AS "VIP_SKILLED",
  "Custom SQL Query"."WV_LICENSE" AS "WV_LICENSE"
FROM (
  SELECT date(c.case_created_est) created_date,
  date(c.case_closed_est) closed_date,
  --c.agent_name,
  c.agent_email,
  c.case_number,
  c.case_type,
  c.case_subtype,
  c.csat_score,
  c.current_casino_segment,
  c.case_source,
  c.current_value_band,
  1 as cases,
  m.*
  FROM fbg_analytics.operations.cs_cases c
  left join fbg_analytics.operations.agent_master_roster m on c.agent_id = m.salesforce_id
  WHERE c.case_type <> 'Fraud'
  AND c.case_type <> 'Responsible Gaming'
  and c.case_status IN ('Resolved')
  ORDER BY created_date DESC
) "Custom SQL Query"
