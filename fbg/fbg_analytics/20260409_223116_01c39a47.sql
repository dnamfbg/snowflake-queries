-- Query ID: 01c39a47-0212-67a9-24dd-07031944bd07
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:31:16.812000+00:00
-- Elapsed: 1428ms
-- Environment: FBG

SELECT "Custom SQL Query5"."ACCO_ID" AS "ACCO_ID (Custom SQL Query5)"
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
