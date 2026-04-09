-- Query ID: 01c39a28-0212-67a9-24dd-0703193de857
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:00:49.825000+00:00
-- Elapsed: 1968ms
-- Environment: FBG

SELECT "Custom SQL Query"."TOTALAUTOS_W" AS "TOTALAUTOS_W",
  "Custom SQL Query"."TOTALBLOCKS_W" AS "TOTALBLOCKS_W",
  "Custom SQL Query"."TOTALPENDS_W" AS "TOTALPENDS_W",
  "Custom SQL Query"."TOTALWITHDRAWALS_W" AS "TOTALWITHDRAWALS_W",
  "Custom SQL Query"."WEEK_SIFT" AS "WEEK_SIFT"
FROM (
  with wdadr as (
  select 
  to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as date, 
  w.user_id, 
  w.decision_source,
  decision_category
  FROM FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  --left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  --on w.user_id = ac.acco_ID and
  --to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) = ac.as_of_date
  where route_name not in ('Leadership Review', 'Test Accounts')
  and workflow_name in ('Withdrawal','NJ Withdrawal')
  )
  
  select 
  date as week_sift,
  count(user_ID) as Totalwithdrawals_w,
  count_if((decision_source = 'automated')) as totalautos_w,
  Totalwithdrawals_w - totalautos_w as totalpends_w,
  count_if((decision_category in ('block'))) as totalblocks_w,
  from wdadr 
  group by all
  order by week_sift asc
) "Custom SQL Query"
