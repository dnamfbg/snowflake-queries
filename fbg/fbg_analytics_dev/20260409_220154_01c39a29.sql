-- Query ID: 01c39a29-0212-67a8-24dd-0703193e37d3
-- Database: FBG_ANALYTICS_DEV
-- Schema: unknown
-- Warehouse: BI_SER_M_WH
-- Executed: 2026-04-09T22:01:54.343000+00:00
-- Elapsed: 71113ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTUAL_HANDLE" AS "ACTUAL_HANDLE",
  "Custom SQL Query"."ACTUAL_LIVE_HANDLE" AS "ACTUAL_LIVE_HANDLE",
  "Custom SQL Query"."ACTUAL_PARLAY_HANDLE" AS "ACTUAL_PARLAY_HANDLE",
  "Custom SQL Query"."ACTUAL_PRE_HANDLE" AS "ACTUAL_PRE_HANDLE",
  "Custom SQL Query"."ACTUAL_SGP_HANDLE" AS "ACTUAL_SGP_HANDLE",
  "Custom SQL Query"."ACTUAL_STRAIGHTS_HANDLE" AS "ACTUAL_STRAIGHTS_HANDLE",
  "Custom SQL Query"."BET_TIMESTAMP" AS "BET_TIMESTAMP",
  "Custom SQL Query"."CURRENT_WEEK_FLAG" AS "CURRENT_WEEK_FLAG",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."EVENT_DATE" AS "EVENT_DATE",
  "Custom SQL Query"."FORECAST_HANDLE" AS "FORECAST_HANDLE",
  "Custom SQL Query"."FORECAST_LIVE_HANDLE" AS "FORECAST_LIVE_HANDLE",
  "Custom SQL Query"."FORECAST_PARLAY_HANDLE" AS "FORECAST_PARLAY_HANDLE",
  "Custom SQL Query"."FORECAST_PRE_HANDLE" AS "FORECAST_PRE_HANDLE",
  "Custom SQL Query"."MAX_TIMESTAMP" AS "MAX_TIMESTAMP",
  "Custom SQL Query"."SGP_PARLAY_HANDLE" AS "SGP_PARLAY_HANDLE",
  "Custom SQL Query"."STRAIGHTS_FORECAST_HANDLE" AS "STRAIGHTS_FORECAST_HANDLE"
FROM (
  //event date forecastr nfl
  
  with
  
  /*transformed_forecast
  
  as
  
  (
  
  SELECT
  
  TO_DATE(TO_CHAR(DATE,'YYYY-MM-DD')) date,
  sum(forecast_handle) forecast_handle,
  sum(forecast_pre_handle) forecast_pre_handle,
  sum(forecast_live_handle) forecast_live_handle,
  sum(straights_forecast_handle) straights_forecast_handle,
  sum(forecast_parlay_handle) forecast_parlay_handle,
  sum(forecast_sgp_handle) sgp_parlay_handle
  FROM
  
    fbg_analytics_Dev.Andrew_mcmahon.NFL_EVENT_FORECASTS FC
  
  
    GROUP BY
  
    ALL
  
    ),*/
  
  
  
  transformed_forecast
  
  as
  
  (
  
  SELECT
  
  TO_DATE(TO_CHAR(forecast_date,'YYYY-MM-DD')) date,
  sum(handle) forecast_handle,
  sum(0) forecast_pre_handle,
  sum(0) forecast_live_handle,
  sum(0) straights_forecast_handle,
  sum(0) forecast_parlay_handle,
  sum(0) sgp_parlay_handle
  FROM
  
    fbg_analytics_Dev.Andrew_mcmahon.daily_forecast FC
  
  WHERE
      forecast_date >= '2025-09-01'
      AND
      lower(sport) = 'nfl'
  
  
    GROUP BY
  
    ALL
  
    ),
  
  
  date_settled
  
  as
  
  (SELECT
  
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) AS event_DATE,
  case when DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', current_timestamp)) between egw.week_start_date and egw.week_end_date then 1 else 0 end current_week_flag,
  SUM(CASE WHEN BET_TYPE = 'SINGLE' THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_STRAIGHTS_HANDLE,
  SUM(CASE WHEN build_a_bet = FALSE and BET_TYPE <> 'SINGLE' THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_PARLAY_HANDLE,
  SUM(CASE WHEN build_a_bet = TRUE  THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_SGP_HANDLE,
  SUM(total_stake/num_lines) AS ACTUAL_HANDLE,
  SUM(CASE WHEN LIVE_BET = 1 THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_LIVE_HANDLE,
  SUM(CASE WHEN LIVE_BET = FALSE THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_PRE_HANDLE,
  max(CONVERT_TIMEZONE('UTC','America/Anchorage', greatest(bets.placed_time,bets.settlement_time))) bet_timestamp 
  
  
  
  
  
  
  FROM
  
  
  fbg_source.osb_source.bets inner join fbg_source.osb_source.bet_parts on (bets.id = bet_parts.bet_id)
                             inner join fbg_source.osb_source.accounts on (bets.acco_id = accounts.id) 
                             left outer join fbg_analytics.trading.football_game_weeks_ egw on DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) between egw.week_start_date and egw.week_end_date and case when lower(bet_parts.comp) like '%nfl%' then 1 when lower(bet_parts.comp) like '%ncaa%' then 2 else 0 end = egw.comp_join_flag
                             left outer join fbg_analytics.trading.market_definitions  md on bet_parts.mrkt_type = md.market_type
                             
  
  WHERE
  
  accounts.test = 0
  and
  lower(bet_parts.sport) = 'american_football'
  AND
  case when lower(bet_parts.comp) like '%nfl%' then 1 
       when lower(bet_parts.comp) like '%ncaa%' then 2 else 0 end = 1
  and
  bets.status NOT IN ('REJECTED','VOID')
  and
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) >= '2025-09-04'
  and
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) >= '2023-03-01'
  and
  CASE
      WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
      ELSE bets.FREE_BET
  END = FALSE
  and
  lower(tier1_group) not like '%future%'
  and
  bets.channel = 'INTERNET'
  
  GROUP BY
  
  ALL
  
  )
  
  select
  
  
  *,
  max(bet_timestamp) over (partition by 1) max_timestamp
  
   from 
  
  transformed_forecast left outer join date_settled on transformed_forecast.date = date_settled.event_DATE
  WHERE DATE IS NOT NULL
  ORDER BY DATE ASC
) "Custom SQL Query"
