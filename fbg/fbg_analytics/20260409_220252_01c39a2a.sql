-- Query ID: 01c39a2a-0212-6dbe-24dd-0703193e8643
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:02:52.513000+00:00
-- Elapsed: 17640ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FIRST_NAME" AS "FIRST_NAME",
  "Custom SQL Query"."LAST_ACTIVE" AS "LAST_ACTIVE",
  "Custom SQL Query"."LAST_NAME" AS "LAST_NAME",
  "Custom SQL Query"."LEAD_ID" AS "LEAD_ID",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LOCATION" AS "LOCATION",
  "Custom SQL Query"."PING_TIME_EST" AS "PING_TIME_EST",
  "Custom SQL Query"."STAKE_FACTOR" AS "STAKE_FACTOR",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  WITH users_staging AS (
  
      SELECT
          p.account_id,
          'pinged within 100 meters of Strega' AS location,
          CONVERT_TIMEZONE('UTC','America/New_York', p.row_created_time::TIMESTAMP_NTZ) AS ping_time_est,
          TRY_CAST(p.latitude AS FLOAT) AS ip_latitude,
          TRY_CAST(p.longitude AS FLOAT) AS ip_longitude,
          ST_DISTANCE(
              ST_MAKEPOINT(-71.0532, 42.365),
              ST_MAKEPOINT(TRY_CAST(p.longitude AS FLOAT), TRY_CAST(p.latitude AS FLOAT))
          ) AS distance_in_meters
      FROM FBG_ANALYTICS_ENGINEERING.APPLICATION.GEOLOCATION_PINGS_FANGEO p
      WHERE TRY_CAST(p.latitude AS FLOAT) IS NOT NULL
        AND TRY_CAST(p.longitude AS FLOAT) IS NOT NULL
        AND DATE(CONVERT_TIMEZONE('UTC','America/New_York', p.row_created_time::TIMESTAMP_NTZ)) = '2026-03-22'
        AND ST_DISTANCE(
              ST_MAKEPOINT(-71.0532, 42.365),
              ST_MAKEPOINT(TRY_CAST(p.longitude AS FLOAT), TRY_CAST(p.latitude AS FLOAT))
            ) <= 100
  
  ),
  
  users AS (
      SELECT
          account_id AS acco_id,
          location,
          ping_time_est
      FROM users_staging
      QUALIFY ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY ping_time_est ASC) = 1
  ),
  
  last_active AS (
      SELECT
          acco_id,
          DATE(MAX(CONVERT_TIMEZONE('UTC','America/New_York', trans_date))) AS last_active
      FROM fbg_source.osb_source.account_statements
      WHERE trans = 'STAKE'
      GROUP BY acco_id
  )
  
  SELECT
      b.location,
      b.ping_time_est,
      a.acco_id,
      a.status,
      a.first_name,
      a.last_name,
      la.last_active,
      a.f1_loyalty_tier,
      a.vip_host,
      a.pre_match_stake_coefficient AS stake_factor,
      ui.lead_id,
      ui.lead_owner
  FROM fbg_analytics_engineering.customers.customer_mart a
  INNER JOIN users b
      ON TO_CHAR(a.acco_id) = b.acco_id
  LEFT JOIN last_active la
      ON a.acco_id = la.acco_id
  LEFT JOIN fbg_analytics.vip.vip_user_info ui
      ON a.acco_id = ui.acco_id
  WHERE a.is_test_account = FALSE
) "Custom SQL Query"
