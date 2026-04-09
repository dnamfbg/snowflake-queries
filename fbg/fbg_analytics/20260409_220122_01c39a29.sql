-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e1da3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:01:22.315000+00:00
-- Elapsed: 202ms
-- Environment: FBG

SELECT "Custom SQL Query1"."ACCO_ID" AS "ACCO_ID (Custom SQL Query1)",
  "Custom SQL Query1"."CALENDAR_DATE" AS "CALENDAR_DATE",
  "Custom SQL Query1"."ENGR" AS "ENGR",
  "Custom SQL Query1"."OC_APD" AS "OC_APD",
  "Custom SQL Query1"."OC_ENGR" AS "OC_ENGR",
  "Custom SQL Query1"."OSB_APD" AS "OSB_APD",
  "Custom SQL Query1"."OSB_ENGR" AS "OSB_ENGR",
  "Custom SQL Query1"."TOTAL_APD" AS "TOTAL_APD"
FROM (
  with deposit_offers as (
      select 
          account_id as acco_id,
          offer,
          offer_date
      from fbg_analytics_dev.luke_harmon.march_madness_dm_2026 
  )
  
  -- select
  -- *
  -- from deposit_offers d
  -- left join fbg_analytics.product_and_customer.t_calendar cal
  -- on cal.calendar_date >= '2025-08-18' and cal.calendar_date < current_date;
  
  select 
      d.acco_id,
      cal.calendar_date,
      -- a.bus_date,
      max(nvl(is_active_day,0)) osb_apd,
      max(nvl(oc_active_day,0)) oc_apd,
      greatest(osb_apd, oc_apd) total_apd,
      sum(nvl(expected_sportsbook_ngr, 0)) osb_engr,
      sum(nvl(expected_casino_ngr, 0)) oc_engr,
      osb_engr + oc_engr as engr
  
  from deposit_offers d
  left join fbg_analytics.product_and_customer.t_calendar cal
  on cal.calendar_date >= '2026-03-09' and cal.calendar_date < current_date
  left join fbg_analytics.product_and_customer.account_revenue_summary_daily a
  on d.acco_id = a.acco_id
  and cal.calendar_date = a.bus_date
  -- where a.bus_date >= '2025-08-18'
  group by all
) "Custom SQL Query1"
