-- Query ID: 01c39a39-0212-67a8-24dd-07031941ac47
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:37.111000+00:00
-- Elapsed: 7939ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTUAL" AS "ACTUAL",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."FBGTOTAL" AS "FBGTOTAL",
  "Custom SQL Query"."FORECAST" AS "FORECAST",
  "Custom SQL Query"."ORIGINALFORECAST" AS "ORIGINALFORECAST",
  "Custom SQL Query"."VERTICAL" AS "VERTICAL",
  "Custom SQL Query"."VIPTYPE" AS "VIPTYPE"
FROM (
  select
  bus_date as date,
  case when subledger_application = 'iGaming' then 'Online Sportsbook'
  when subledger_application = 'iCasino' then 'Online Casino'
  else subledger_application end Vertical,
  case when vip_status_year = 'new' then 'New'
  when vip_status_year in ('existing','former') then 'Existing' END VIPType,
  sum(priced_ngr) Actual, 0 Forecast,0 OriginalForecast, 0 FBGTotal
  from fbg_finance.finance_mart.daily_customer_rev a
  inner join fbg_analytics_engineering.customers.customer_mart cm on cm.acco_id = a.customer_id
  join fbg_analytics.vip.vip_status_history vs on vs.calendar_date=a.bus_date and vs.acco_id=a.customer_id
  inner join fbg_analytics.vip.vip_user_info u on a.customer_id = u.acco_id
  where 1=1
  and vip_status_day = 'vip'
  and u.vip_attribution = 'CDE'
  and bus_date >= '2025-01-01'
  and bus_date < date(current_timestamp)
  and cm.is_test_account = 0
  and subledger_application in ('iGaming', 'iCasino')
  group by all
  union
  select
  date,
  case when product = 'sbk' then 'Online Sportsbook'
  when product = 'casino' then 'Online Casino' 
  else NULL end Vertical,
  'New',
  0,
  sum(NEW_NGR_FC_ACQ),
  sum(NEW_NGR_FC_OG_ACQ),
  0
  from fbg_analytics.vip.vip_ngr_forecast_acq
  group by all
  union
  select
  date,
  case when product = 'sbk' then 'Online Sportsbook'
  when product = 'casino' then 'Online Casino' 
  else NULL end Vertical,
  'Existing',
  0,
  sum(existing_NGR_FC_ACQ),
  sum(EXISTING_NGR_FC_OG_ACQ),
  0
  from fbg_analytics.vip.vip_ngr_forecast_acq
  group by all
  union
  select
  bus_date as date,
  case when subledger_application = 'iGaming' then 'Online Sportsbook'
  when subledger_application = 'iCasino' then 'Online Casino'
  else subledger_application end Vertical,
  'Total FBG' as VIPType,
  0 Actual, 0 Forecast, 0 OriginalForecast, sum(priced_ngr) 
  from fbg_finance.finance_mart.daily_customer_rev a
  inner join fbg_analytics_engineering.customers.customer_mart cm on cm.acco_id = a.customer_id
  where 1=1
  and bus_date >= '2025-01-01'
  and bus_date < date(current_timestamp)
  and cm.is_test_account = 0
  and subledger_application in ('iGaming', 'iCasino')
  group by all
) "Custom SQL Query"
