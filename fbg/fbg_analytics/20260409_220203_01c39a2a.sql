-- Query ID: 01c39a2a-0212-644a-24dd-0703193e62cf
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:03.767000+00:00
-- Elapsed: 11915ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."ADDITIONAL_COMMENTS__C" AS "ADDITIONAL_COMMENTS__C",
  "Custom SQL Query"."AGENT_EMAIL" AS "AGENT_EMAIL",
  "Custom SQL Query"."AGENT_ID" AS "AGENT_ID",
  "Custom SQL Query"."AGENT_NAME" AS "AGENT_NAME",
  "Custom SQL Query"."AGENT_TYPE" AS "AGENT_TYPE",
  "Custom SQL Query"."CASE_ID" AS "CASE_ID",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SOURCE" AS "CASE_SOURCE",
  "Custom SQL Query"."CASE_STATUS" AS "CASE_STATUS",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CLOSED_DATE" AS "CLOSED_DATE",
  "Custom SQL Query"."COUNT_REVIEWS" AS "COUNT_REVIEWS",
  "Custom SQL Query"."CREATED_DATE" AS "CREATED_DATE",
  TRY_CAST("Custom SQL Query"."CSAT" AS INT) AS "CSAT",
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
  "Custom SQL Query"."ISSUE_RESOLVED__C" AS "ISSUE_RESOLVED__C",
  "Custom SQL Query"."LAST_MODIFIED_DATE" AS "LAST_MODIFIED_DATE",
  "Custom SQL Query"."LEAVE_END_DATE" AS "LEAVE_END_DATE",
  "Custom SQL Query"."LIFE_CYCLE" AS "LIFE_CYCLE",
  "Custom SQL Query"."LIKELIHOODREC" AS "LIKELIHOODREC",
  "Custom SQL Query"."NJ_LICENSE" AS "NJ_LICENSE",
  "Custom SQL Query"."PA_LICENCE" AS "PA_LICENCE",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG",
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
  SELECT date_trunc('minute', a.case_created_est) as created_date,
  date_trunc('minute', a.case_closed_est) as closed_date,
  a.case_number,
  a.account_id,
  a.current_value_band,
  a.current_casino_segment,
  a.case_status,
  a.case_id,
  a.case_source,
  --a.agent_name,
  a.agent_email,
  a.product_flag,
  a.case_type,
  a.case_subtype,
  date_trunc('minute', a.last_modified_est) as last_modified_date,
  case when a.lifecycle in ('New','Pre-FTB','Early') then 'Early Life' else 'Other' end as Life_cycle,
  b.issue_resolved__c,
  (b.likelihood_to_recommend__c) as LikelihoodRec,
  (b.overall_satisfaction__c) as CSAT,
  b.additional_comments__c,
  1 as count_reviews,
  m.*
  FROM fbg_analytics.operations.cs_cases a
  LEFT JOIN FBG_SOURCE.SALESFORCE.O_CSAT_SURVEY__C b on b.case__c = a.case_id
  LEFT JOIN fbg_analytics.operations.agent_master_roster m on a.agent_id = m.salesforce_id
  where B.STATUS__C='Completed' and (a.case_type not in ('Fraud','Responsible Gaming') or a.case_type is null) and b.overall_satisfaction__c <> 'None' and a.case_status IN ('Resolved') 
  ORDER BY closed_date DESC
) "Custom SQL Query"
