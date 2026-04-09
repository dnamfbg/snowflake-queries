-- Query ID: 01c39a29-0212-6dbe-24dd-0703193e272b
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:01:30.036000+00:00
-- Elapsed: 38232ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."CASENUMBER" AS "CASENUMBER",
  CAST("Custom SQL Query"."CREATED_DATE" AS DATE) AS "CREATED_DATE",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."ORIGIN" AS "ORIGIN",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."SUB_TYPE__C" AS "SUB_TYPE__C",
  "Custom SQL Query"."TYPE" AS "TYPE",
  "Custom SQL Query"."USER_SEGMENT" AS "USER_SEGMENT",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  SELECT DISTINCT c.casenumber,
  convert_timezone('UTC', 'America/New_York', try_to_timestamp(concat_ws(' ',SPLIT_PART(c.createddate,'T',1),left(SPLIT_PART(c.createddate,'T',2),12)))) as created_date,
  --a.companyname,
  c.origin,
  u.current_value_band as user_segment,
  c.sub_type__c,
  c.type,
  u.current_state,
  c.status,
  u.vip_host
  FROM FBG_SOURCE.SALESFORCE.O_CASE c
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a on a.email=c.contactemail
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart u on a.id = u.acco_id
) "Custom SQL Query"
