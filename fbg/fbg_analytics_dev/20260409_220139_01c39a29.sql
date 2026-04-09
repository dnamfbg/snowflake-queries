-- Query ID: 01c39a29-0212-644a-24dd-0703193e60bb
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:01:39.969000+00:00
-- Elapsed: 13406ms
-- Environment: FBG

SELECT "Custom SQL Query"."PENDEDWITHDRAWALTIME" AS "PENDEDWITHDRAWALTIME",
  "Custom SQL Query"."WEEK_SIFT" AS "WEEK_SIFT"
FROM (
  with wd as (
  select 
  datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendedwithdrawaltime,
  to_date(convert_timezone('UTC','America/New_York',WORKFLOW_RUN_START_TIME)) as date,
  HIGH_LEVEL_SEGMENT
  from FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  on w.user_id = ac.acco_ID and
  to_date(convert_timezone('UTC','America/New_York',WORKFLOW_RUN_START_TIME)) = ac.as_of_date
  left join fbg_source.osb_source.accounts a on ac.acco_id = a.id
  where decision_source = 'manual' 
  and a.test = 0 
  and workflow_name in ('Withdrawal','NJ Withdrawal')
  and high_level_segment = 'VIP'
  and route_name not in ('Leadership Review', 'Test Accounts','VIP Cash At Cage Licensed States','VIP Cash At Cage Non Licensed States','NJ VIP Cash At Cage','NJ Cash at Cage','Cash at Cage')),
  
  
  wdfinal as(
  select
  date as week_pend,
  round(avg(pendedwithdrawaltime)) as AVPENDEDGWDTIME_w,
  count_if(pendedwithdrawaltime > 30) as wdsover30_w
  from wd
  group by all
  order by week_pend asc)
  
  
  select 
  date as week_sift, 
  avg(pendedwithdrawaltime) as pendedwithdrawaltime
  from wd a
  group by all
  order by week_sift asc
) "Custom SQL Query"
