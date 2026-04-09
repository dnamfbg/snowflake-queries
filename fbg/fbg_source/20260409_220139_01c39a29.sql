-- Query ID: 01c39a29-0212-644a-24dd-0703193e60ab
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:01:39.655000+00:00
-- Elapsed: 26373ms
-- Environment: FBG

SELECT "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SOURCE" AS "CASE_SOURCE",
  "Custom SQL Query"."CASE_STATUS" AS "CASE_STATUS",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CHANNEL_NAME" AS "CHANNEL_NAME",
  "Custom SQL Query"."CODED_CAS_TIER" AS "CODED_CAS_TIER",
  "Custom SQL Query"."CODED_OSB_TIER" AS "CODED_OSB_TIER",
  "Custom SQL Query"."CREATED_DATE" AS "CREATED_DATE",
  "Custom SQL Query"."CURRENT_CASINO_SEGMENT" AS "CURRENT_CASINO_SEGMENT",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."IS_CONTAINED" AS "IS_CONTAINED",
  "Custom SQL Query"."ORIGIN" AS "ORIGIN",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG",
  "Custom SQL Query"."USER_SEGMENT" AS "USER_SEGMENT",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  SELECT DISTINCT c.case_number,
  date(case_created_est) as created_date,
  c.origin,
  u.current_value_band as user_segment,
  c.case_subtype,
  case when lower(c.origin) like '%voice%' then 'Voicemail' else c.case_source end as case_source,
  c.case_type,
  u.current_state,
  c.case_status,
  c.current_casino_segment,
  u.vip_host,
  c.is_contained,
  v.coded_cas_tier,
  v.coded_osb_tier,
  c.product_flag,
  c.channel_name
  FROM fbg_analytics.operations.cs_cases c
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart u on u.acco_id = c.account_id
  LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VIP_TIERS v on v.acco_id = u.acco_id
  ORDER BY case_number
) "Custom SQL Query"
