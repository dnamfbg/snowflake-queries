-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4cb7
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:02:17.479000+00:00
-- Elapsed: 1275ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."AVG(CASE_TIME_MINUTES)" AS "AVG(CASE_TIME_MINUTES)",
  CAST("Custom SQL Query"."DAY" AS DATE) AS "DAY",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE"
FROM (
  select date_trunc('day',case_created_utc) as day, 
  --case when case_type = 'KYC' then 'Y' else 'N' end as "tester",
  avg(case_time_minutes),
  b.registration_state
  from fbg_analytics.operations.cs_cases a
  left join fbg_analytics_engineering.customers.customer_mart b ON a.account_id = b.acco_id
  where a.case_type = 'KYC'
  group by all
  order by 1 desc,2 desc
) "Custom SQL Query"
