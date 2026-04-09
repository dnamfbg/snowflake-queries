-- Query ID: 01c399ed-0212-6e7d-24dd-0703192fbd3f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:01:41.313000+00:00
-- Elapsed: 90089ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."DEPOSIT_AMOUNT" AS "DEPOSIT_AMOUNT",
  "Custom SQL Query"."FOOTBALL_CASH_HANDLE" AS "FOOTBALL_CASH_HANDLE",
  "Custom SQL Query"."FOOTBALL_NGR" AS "FOOTBALL_NGR",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."RANK" AS "RANK",
  "Custom SQL Query"."START_DATE" AS "START_DATE",
  "Custom SQL Query"."WEEK" AS "WEEK"
FROM (
  WITH users AS (
  SELECT DISTINCT 
  acco_id 
  , status 
  , f1_loyalty_tier
  FROM fbg_analytics_engineering.customers.customer_mart 
  WHERE is_test_account = FALSE
  AND vip_host IS NOT NULL
  )
  
  , nfl_weeks AS (
  SELECT DISTINCT
  acco_id 
  , week 
  , rank
  , start_date
  , end_date
  FROM fbg_analytics.vip.football_schedule AS f
  JOIN users AS u 
      ON 1=1
  WHERE f.year = 2025
  AND f.league = 'NFL'
  )
  
  SELECT DISTINCT 
  n.acco_id
  , n.week
  , n.start_date
  , n.rank
  , COALESCE(SUM(total_cash_stake_by_legs), 0) AS cash_handle
  , COALESCE(SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END), 0) AS football_cash_handle
  , COALESCE(SUM(total_ngr_by_legs), 0) AS ngr
  , COALESCE(SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_ngr_by_legs END), 0) AS football_ngr
  , COALESCE(SUM(CASE WHEN d.payment_brand <> 'TERMINAL' AND d.status = 'DEPOSIT_SUCCESS' THEN amount END), 0) AS deposit_amount
  FROM nfl_weeks AS n
  LEFT JOIN fbg_analytics_engineering.trading.trading_sportsbook_mart AS t
      ON t.wager_placed_time_est >= n.start_date 
      AND t.wager_placed_time_est <= n.end_date
      AND n.acco_id = t.account_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.DEPOSITS AS d 
      ON CONVERT_TIMEZONE('America/Toronto', d.completed_at) >= n.start_date
      AND CONVERT_TIMEZONE('America/Toronto', d.completed_at) <= n.end_date
      AND n.acco_id = d.acco_id
  GROUP BY
  ALL
) "Custom SQL Query"
