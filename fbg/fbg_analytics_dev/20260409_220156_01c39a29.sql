-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e49ff
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:56.909000+00:00
-- Elapsed: 2769ms
-- Environment: FBG

SELECT "Custom SQL Query"."ADR_OVR" AS "ADR_OVR",
  "Custom SQL Query"."DAY_WITH_OVR" AS "DAY_WITH_OVR",
  "Custom SQL Query"."TOTALAUTOS_OVR" AS "TOTALAUTOS_OVR",
  "Custom SQL Query"."TOTALWITHDRAWALS_OVR" AS "TOTALWITHDRAWALS_OVR"
FROM (
  with wdadr as (
  select 
  to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as date, 
  w.user_id, 
  w.decision_source
  FROM FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  --left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  --on w.user_id = ac.acco_ID and
  --to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) = ac.as_of_date
  where workflow_name in ('Withdrawal','NJ Withdrawal')
  )
  
  
  select 
  date as day_with_ovr,
  count(user_ID) as totalwithdrawals_ovr,
  count_if((decision_source = 'automated')) as totalautos_ovr,
  totalautos_ovr/totalwithdrawals_ovr as ADR_ovr
  from wdadr
  where date > DATEADD(DAY,-15,current_date) 
  and date <> current_date
  group by all
  order by day_with_ovr asc
) "Custom SQL Query"
