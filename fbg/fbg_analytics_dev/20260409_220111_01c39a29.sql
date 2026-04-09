-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e1a2f
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:11.236000+00:00
-- Elapsed: 4536ms
-- Environment: FBG

SELECT "Custom SQL Query"."AVPENDEDGWDTIME_NON_VIP" AS "AVPENDEDGWDTIME_NON_VIP",
  "Custom SQL Query"."DAY_PEND_NON_VIP" AS "DAY_PEND_NON_VIP"
FROM (
  with wd as (
  select 
  datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendedwithdrawaltime,
  to_date(convert_timezone('UTC','America/New_York',decision_time)) as date,
  HIGH_LEVEL_SEGMENT, w.user_id
  from FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  on w.user_id = ac.acco_ID and
  to_date(convert_timezone('UTC','America/New_York',decision_time)) = ac.as_of_date
  left join fbg_source.osb_source.accounts a on w.user_id = a.id
  where decision_source = 'manual' and a.test = 0 
  and route_name not in ('Leadership Review', 'Test Accounts','VIP Cash At Cage Licensed States','VIP Cash At Cage Non Licensed States','NJ VIP Cash At Cage','NJ Cash at Cage','Cash at Cage','Trading Pends','Trustly Return Pends VIP')
  and workflow_name in ('Withdrawal','NJ Withdrawal')
  and (HIGH_LEVEL_SEGMENT <> 'VIP' or high_level_segment is null)
  )
  
  
  
  --step 2.5 --- group by segment & day ---
  select
  date as day_pend_non_vip,
  round(avg(pendedwithdrawaltime)) as AVPENDEDGWDTIME_non_vip
  from wd
  where date > DATEADD(DAY,-15,current_date) 
  and date <> current_date
  group by all ORDER BY day_pend_non_vip desc
) "Custom SQL Query"
