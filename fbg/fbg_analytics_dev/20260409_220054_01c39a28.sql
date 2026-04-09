-- Query ID: 01c39a28-0212-6cb9-24dd-0703193e13db
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:00:54.320000+00:00
-- Elapsed: 4631ms
-- Environment: FBG

SELECT "Custom SQL Query"."ALERTPENDTIME" AS "ALERTPENDTIME",
  "Custom SQL Query"."DATE" AS "DATE"
FROM (
  ---- Alert Pend Time
  with wd as (
  select 
  datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendtime,
  to_date(convert_timezone('UTC','America/New_York',WORKFLOW_RUN_START_TIME)) as date,
  w.user_id
  from FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join fbg_source.osb_source.accounts a on w.user_id = a.id
  where decision_source = 'manual' and a.test = 0 
  --and route_name in ('Suspicious Deposit Activity Alert', 'NJ Suspicious Deposit Activity Alert')
  and route_name in ('Name Mismatch Alert', 'Stacked Deposit Alert','Suspicious Deposit Activity Alert','NJ Name Mismatch Alert','NJ Stacked Deposit Alert','NJ Suspicious Deposit Activity Alert')
  )
  
  
  select
  date,
  round(avg(pendtime)) as alertpendtime
  from wd
  group by all
  order by date asc
) "Custom SQL Query"
