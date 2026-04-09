-- Query ID: 01c399fa-0212-6b00-24dd-07031932ee63
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:14:44.134000+00:00
-- Elapsed: 30836ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."DAY_OF_WEEK" AS "DAY_OF_WEEK",
  "Custom SQL Query"."DOW_NUM" AS "DOW_NUM",
  "Custom SQL Query"."END_DATE" AS "END_DATE",
  "Custom SQL Query"."ENGR" AS "ENGR",
  "Custom SQL Query"."FOOTBALL_ENGR" AS "FOOTBALL_ENGR",
  "Custom SQL Query"."FOOTBALL_HANDLE" AS "FOOTBALL_HANDLE",
  "Custom SQL Query"."FOOTBALL_NGR" AS "FOOTBALL_NGR",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."IS_VIP" AS "IS_VIP",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."RANK" AS "RANK",
  "Custom SQL Query"."START_DATE" AS "START_DATE",
  "Custom SQL Query"."WEEK" AS "WEEK"
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
  
  
  SELECT DISTINCT
  account_id AS acco_id
  , DATE_TRUNC('DAY', wager_placed_time_est)::DATE AS day 
  , DAYNAME(DATE_TRUNC('DAY', wager_placed_time_est)::DATE) AS day_of_week
  , (DAYOFWEEK(DATE_TRUNC('DAY', wager_placed_time_est)::DATE) + 6) % 7 AS dow_num
  , CASE WHEN h.acco_id IS NOT NULL THEN 1 ELSE 0 END AS is_vip
  , f.week
  , f.rank 
  , f.start_date
  , f.end_date
  , SUM(COALESCE(CASE WHEN t.wager_status = 'SETTLED' THEN total_ngr_by_legs END, 0)) AS ngr
  , SUM(COALESCE(CASE WHEN t.wager_status = 'SETTLED' THEN expected_ngr_by_legs END, 0)) AS engr
  , SUM(COALESCE(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND t.wager_status = 'SETTLED' THEN total_ngr_by_legs END, 0)) AS football_ngr
  , SUM(COALESCE(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND t.wager_status = 'SETTLED' THEN expected_ngr_by_legs END, 0)) AS football_engr
  , SUM(COALESCE(total_cash_stake_by_legs, 0)) AS handle
  , SUM(COALESCE(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END, 0)) AS football_handle
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
) "Custom SQL Query"
