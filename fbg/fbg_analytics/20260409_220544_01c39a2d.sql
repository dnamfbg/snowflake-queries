-- Query ID: 01c39a2d-0212-644a-24dd-0703193f5043
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:05:44.188000+00:00
-- Elapsed: 3877ms
-- Environment: FBG

SELECT "Custom SQL Query5"."ACCO_ID" AS "ACCO_ID (Custom SQL Query5)",
  "Custom SQL Query5"."FBG_FTCU_DATE_EST" AS "FBG_FTCU_DATE_EST",
  "Custom SQL Query5"."LAST_LOGIN_TIME_EST" AS "LAST_LOGIN_TIME_EST",
  "Custom SQL Query5"."REG_DATE" AS "REG_DATE"
FROM (
  select
  a.acco_id,
  date(b.registration_date_est) as reg_date,
  b.last_login_time_est,
  b.fbg_ftcu_date_est
  from fbg_analytics.product_and_customer.fast_track_attribute a
  join fbg_analytics_engineering.customers.customer_mart b on a.acco_id = b.acco_id
  group by all
) "Custom SQL Query5"
