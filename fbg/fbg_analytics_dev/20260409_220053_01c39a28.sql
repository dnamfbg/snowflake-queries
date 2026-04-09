-- Query ID: 01c39a28-0212-6e7d-24dd-0703193df997
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:00:53.637000+00:00
-- Elapsed: 2401ms
-- Environment: FBG

SELECT "Custom SQL Query"."ADR_NON_VIP" AS "ADR_NON_VIP",
  "Custom SQL Query"."DAY_WITH_NON_VIP" AS "DAY_WITH_NON_VIP",
  "Custom SQL Query"."TOTALAUTOS_NON_VIP" AS "TOTALAUTOS_NON_VIP",
  "Custom SQL Query"."TOTALWITHDRAWALS_NON_VIP" AS "TOTALWITHDRAWALS_NON_VIP"
FROM (
  with wdadr as (
  select 
  to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as date, 
  ac.HIGH_LEVEL_SEGMENT, 
  w.user_id, 
  w.decision_source, 
  FROM FBG_SOURCE.SIFT.WORKFLOW_METRICS w
  left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VALUE_BANDS_HISTORICAL ac 
  on w.user_id = ac.acco_ID and
  to_date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) = ac.as_of_date
  where workflow_name in ('Withdrawal','NJ Withdrawal')
  and (HIGH_LEVEL_SEGMENT <> 'VIP' or high_level_segment is null)
  )
  
  
  select 
  date as day_with_non_vip,
  count(user_ID) as Totalwithdrawals_non_vip,
  count_if((decision_source = 'automated')) as totalautos_non_vip,
  totalautos_non_vip/totalwithdrawals_non_vip as ADR_non_vip
  from wdadr
  where date > DATEADD(DAY,-15,current_date) 
  and date <> current_date
  --and (HIGH_LEVEL_SEGMENT not in ('VIP') or high_level_segment is null)
  group by all
  order by day_with_non_vip asc
) "Custom SQL Query"
