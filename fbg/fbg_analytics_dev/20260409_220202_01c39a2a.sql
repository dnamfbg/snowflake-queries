-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4ab3
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:02:02.221000+00:00
-- Elapsed: 7078ms
-- Environment: FBG

SELECT "Custom SQL Query"."TOTALBLOCKS_W" AS "TOTALBLOCKS_W",
  "Custom SQL Query"."TOTALPENDS" AS "TOTALPENDS",
  "Custom SQL Query"."WDSOVER30_W" AS "WDSOVER30_W",
  "Custom SQL Query"."WEEK_SIFT" AS "WEEK_SIFT"
FROM (
  with wd as (
  select 
  datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendedwithdrawaltime,
  to_date(convert_timezone('UTC','America/New_York',WORKFLOW_RUN_START_TIME)) as day,
  HIGH_LEVEL_SEGMENT, w.user_id, decision_category
  from FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  on w.user_id = ac.acco_ID and
  to_date(w.WORKFLOW_RUN_START_TIME) = ac.as_of_date
  left join fbg_source.osb_source.accounts a on ac.acco_id = a.id
  where decision_source = 'manual' 
  and a.test = 0 
  and workflow_name in ('Withdrawal','NJ Withdrawal')
  and route_name not in ('Leadership Review', 'Test Accounts','VIP Cash At Cage Licensed States','VIP Cash At Cage Non Licensed States','NJ VIP Cash At Cage','NJ Cash at Cage','Cash at Cage')
  )
  
  
  
  select 
  day as week_sift,
  count(user_ID) as totalpends,
  count_if((decision_category in ('block','watch'))) as totalblocks_w,
  count_if(pendedwithdrawaltime > 30) as wdsover30_w,
  from wd a
  group by all
  order by week_sift asc
) "Custom SQL Query"
