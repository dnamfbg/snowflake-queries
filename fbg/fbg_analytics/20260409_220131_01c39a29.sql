-- Query ID: 01c39a29-0212-67a9-24dd-0703193e5507
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: STRATEGY_XL_WH
-- Executed: 2026-04-09T22:01:31.927000+00:00
-- Elapsed: 44885ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FIRST_NAME" AS "FIRST_NAME",
  "Custom SQL Query"."LAST_ACTIVE" AS "LAST_ACTIVE",
  "Custom SQL Query"."LAST_NAME" AS "LAST_NAME",
  "Custom SQL Query"."LEAD_ID" AS "LEAD_ID",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LOCATION" AS "LOCATION",
  "Custom SQL Query"."PING_TIME_PST" AS "PING_TIME_PST",
  "Custom SQL Query"."STAKE_FACTOR" AS "STAKE_FACTOR",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  with users_staging as(
  -- 
  SELECT
      p.account_id,
      'Waste Management Open' as location,
      CONVERT_TIMEZONE('UTC','America/Los_Angeles',p.row_created_time::TIMESTAMP_NTZ) as ping_time_pst,
      TRY_CAST(p.latitude AS FLOAT) AS ip_latitude,
      TRY_CAST(p.longitude AS FLOAT) AS ip_longitude,
      ST_DISTANCE(
          ST_MAKEPOINT(-111.89942371702664, 33.63620606363957),
          ST_MAKEPOINT(p.longitude, p.latitude)
      ) AS distance_in_meters
  FROM FBG_ANALYTICS_ENGINEERING.APPLICATION.GEOLOCATION_PINGS_FANGEO p
  WHERE TRY_CAST(p.latitude AS FLOAT) IS NOT NULL
    AND TRY_CAST(p.longitude AS FLOAT) IS NOT NULL
    AND DATE(CONVERT_TIMEZONE('UTC','America/New_York',p.row_created_time::TIMESTAMP_NTZ)) >= '2026-02-04'
    AND distance_in_meters <= 1000
  
  ),
  
  users as(
  select
  account_id as acco_id,
  location,
  ping_time_pst
  from users_staging
  qualify row_number() OVER (partition BY account_id order by ping_time_pst asc) = 1
  ),
  
  last_active as(
  select
  acco_id,
  date(max(convert_timezone('UTC','America/New_York',trans_date))) as last_active
  from fbg_source.osb_source.account_statements
  where trans = 'STAKE'
  group by all
  )
  
  select
  location,
  ping_time_pst,
  a.acco_id,
  a.status,
  a.first_name,
  a.last_name,
  la.last_active,
  a.f1_loyalty_tier,
  a.vip_host,
  a.pre_match_stake_coefficient as stake_factor,
  ui.lead_id,
  ui.lead_owner
  
  
  from fbg_analytics_engineering.customers.customer_mart a
  inner join users b
      on to_char(a.acco_id) = b.acco_id
  left join last_active la
      on a.acco_id = la.acco_id
  left join fbg_analytics.vip.vip_user_info ui
      on a.acco_id = ui.acco_id
  where a.is_test_account = FALSE
) "Custom SQL Query"
