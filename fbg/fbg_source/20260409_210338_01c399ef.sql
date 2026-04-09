-- Query ID: 01c399ef-0212-67a8-24dd-07031930760f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:03:38.958000+00:00
-- Elapsed: 113ms
-- Environment: FBG

SELECT "Custom SQL Query"."AVG_ENGR" AS "AVG_ENGR",
  "Custom SQL Query"."AVG_FOOTBALL_ENGR" AS "AVG_FOOTBALL_ENGR",
  "Custom SQL Query"."AVG_FOOTBALL_HANDLE" AS "AVG_FOOTBALL_HANDLE",
  "Custom SQL Query"."AVG_FOOTBALL_NGR" AS "AVG_FOOTBALL_NGR",
  "Custom SQL Query"."AVG_HANDLE" AS "AVG_HANDLE",
  "Custom SQL Query"."AVG_NGR" AS "AVG_NGR",
  "Custom SQL Query"."AVG_USERS" AS "AVG_USERS",
  "Custom SQL Query"."DAY_OF_WEEK" AS "DAY_OF_WEEK",
  "Custom SQL Query"."DOW_NUM" AS "DOW_NUM",
  "Custom SQL Query"."IS_VIP" AS "IS_VIP"
FROM (
  WITH historical_host AS (
  SELECT DISTINCT
  e.org
  , e.sr_manager 
  , e.manager
  , e.name
  , e.host_type
  , e.team
  , h.acco_id 
  , h.as_of_date
  FROM fbg_analytics.vip.vip_employee_mapping AS e 
  LEFT JOIN fbg_analytics.vip.vip_host_lead_historical AS h 
      ON e.name = h.vip_host
  WHERE e.sr_manager != 'Taylor Gwiazdon'
  AND h.vip_host IS NOT NULL
  GROUP BY
  ALL
  )
  
  
  , final AS (
  SELECT DISTINCT
  account_id AS acco_id
  , DATE_TRUNC('DAY', wager_placed_time_est)::DATE AS day 
  , DAYNAME(DATE_TRUNC('DAY', wager_placed_time_est)::DATE) AS day_of_week
  --, DAYOFWEEK(DATE_TRUNC('DAY', wager_placed_time_est)::DATE) AS dow_num
  , (DAYOFWEEK(DATE_TRUNC('DAY', wager_placed_time_est)::DATE) + 6) % 7 AS dow_num
  , CASE WHEN h.acco_id IS NOT NULL THEN 1 ELSE 0 END AS is_vip
  , f.week
  , f.rank 
  , f.start_date
  , f.end_date
  , SUM(COALESCE(CASE WHEN t.wager_status = 'SETTLED' THEN total_ngr_by_legs END, 0)) AS ngr_
  , SUM(COALESCE(CASE WHEN t.wager_status = 'SETTLED' THEN expected_ngr_by_legs END, 0)) AS engr_
  , SUM(COALESCE(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND t.wager_status = 'SETTLED' THEN total_ngr_by_legs END, 0)) AS football_ngr_
  , SUM(COALESCE(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND t.wager_status = 'SETTLED' THEN expected_ngr_by_legs END, 0)) AS football_engr_
  , SUM(COALESCE(total_cash_stake_by_legs, 0)) AS handle_
  , SUM(COALESCE(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END, 0)) AS football_handle_
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN fbg_analytics.vip.football_schedule AS f 
      ON DATE_TRUNC('DAY', wager_placed_time_est) >= f.start_date
      AND DATE_TRUNC('DAY', wager_placed_time_est) <= f.end_date
  LEFT JOIN historical_host AS h 
      ON t.account_id = h.acco_id
      AND DATE_TRUNC('DAY', wager_placed_time_est) = h.as_of_date
  WHERE wager_status != 'REJECTED'
  AND wager_placed_time_est >= '2025-09-02'
  GROUP BY 
  ALL
  )
  
  , days AS (
  SELECT DISTINCT 
  week
  , day_of_week
  , dow_num
  , is_vip
  , COUNT(DISTINCT acco_id) AS users
  , SUM(handle_) AS handle
  , SUM(ngr_) AS ngr
  , SUM(engr_) AS engr
  , SUM(football_handle_) AS football_handle
  , SUM(football_ngr_) AS football_ngr
  , SUM(football_engr_) AS football_engr
  FROM final 
  GROUP BY 1, 2, 3, 4
  )
  
  SELECT DISTINCT 
  day_of_week
  , dow_num
  , is_vip
  , AVG(users) AS avg_users
  , AVG(handle) AS avg_handle
  --, AVG(handle) / AVG(users) AS avg_handle_per_user
  , AVG(ngr) AS avg_ngr
  --, AVG(ngr) / AVG(users) AS avg_ngr_per_user
  , AVG(engr) AS avg_engr
  , AVG(football_handle) AS avg_football_handle
  --, AVG(football_handle) / AVG(users) AS avg_football_handle_per_user
  , AVG(football_ngr) AS avg_football_ngr
  --, AVG(football_ngr) / AVG(users) AS avg_football_ngr_per_user
  , AVG(football_engr) AS avg_football_engr
  FROM days
  GROUP BY 1, 2, 3
) "Custom SQL Query"
