-- Query ID: 01c39a29-0212-67a8-24dd-0703193e3743
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:01:47.401000+00:00
-- Elapsed: 6238ms
-- Environment: FBG

SELECT "Custom SQL Query"."ANALYST_EMAIL" AS "ANALYST_EMAIL",
  "Custom SQL Query"."AVGPENDTIME" AS "AVGPENDTIME",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."PENDSOVER30" AS "PENDSOVER30",
  "Custom SQL Query"."WDS" AS "WDS"
FROM (
  with wd as (
  select to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as date, 
  analyst_email, decision_time,
  datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendedwithdrawaltime,
  w.user_id,
  case when pendedwithdrawaltime >30 then 1 else null end as pendsover30
  from FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join fbg_source.osb_source.accounts a on w.user_id = a.id
  where decision_source = 'manual' 
  and a.test = 0
  and workflow_name in ('Withdrawal','NJ Withdrawal')
  --and route_name not in ('Leadership Review', 'Test Accounts','VIP Cash At Cage Licensed States','VIP Cash At Cage Non Licensed States','NJ VIP Cash At Cage','NJ Cash at Cage','Cash at Cage')
  )
  
  SELECT date, analyst_email, count(decision_time) as wds, avg(pendedwithdrawaltime) as avgpendtime,
  count(pendsover30) as pendsover30
  FROM wd
  group by all
  order by date asc
) "Custom SQL Query"
