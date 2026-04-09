-- Query ID: 01c39a54-0212-67a9-24dd-070319479293
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:44:06.846000+00:00
-- Elapsed: 2853ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACQ_BONUS_NAME_ON_REG" AS "ACQ_BONUS_NAME_ON_REG",
  "Custom SQL Query"."CHANNEL" AS "CHANNEL",
  "Custom SQL Query"."DW_UPDATE_TS_EST" AS "DW_UPDATE_TS_EST",
  "Custom SQL Query"."FBG_FTU_DATE" AS "FBG_FTU_DATE",
  "Custom SQL Query"."FIRST_PRODUCT" AS "FIRST_PRODUCT",
  "Custom SQL Query"."REG_DATE" AS "REG_DATE",
  "Custom SQL Query"."REG_STATE" AS "REG_STATE",
  "Custom SQL Query"."SUB_CHANNEL" AS "SUB_CHANNEL",
  "Custom SQL Query"."USERS" AS "USERS"
FROM (
  with last_update as(
  select
  max(convert_timezone('UTC','America/New_York',last_modified_date)) as dw_update_ts_est
  from fbg_analytics_engineering.customers.customer_mart
  )
  
  select
  date_trunc('hour',a.registration_date_est) as reg_date,
  date_trunc('hour',a.fbg_ftu_date_est) as fbg_ftu_date,
  a.acquisition_channel as channel,
  a.acquisition_sub_channel as sub_channel,
  a.registration_state as reg_state,
  a.acquisition_bonus_name as acq_bonus_name_on_reg,
  a.first_product,
  count(distinct a.acco_id) as users,
  b.dw_update_ts_est
  
  from fbg_analytics_engineering.customers.customer_mart as a
  left join last_update as b on 1=1
  where is_test_account = 0
  and is_kiosk = 0
  and (date(registration_date_est) >= dateadd(day,-30,date(current_timestamp))
      OR date(fbg_ftu_date_est) >= dateadd(day,-30,date(current_timestamp)))
  group by all
) "Custom SQL Query"
