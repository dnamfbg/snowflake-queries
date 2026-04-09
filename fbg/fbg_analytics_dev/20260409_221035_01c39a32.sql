-- Query ID: 01c39a32-0212-6e7d-24dd-0703194081e7
-- Database: FBG_ANALYTICS_DEV
-- Schema: unknown
-- Warehouse: BI_SER_M_WH_PROD
-- Executed: 2026-04-09T22:10:35.514000+00:00
-- Elapsed: 44672ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTUAL_HANDLE" AS "ACTUAL_HANDLE",
  "Custom SQL Query"."ACTUAL_LIVE_HANDLE" AS "ACTUAL_LIVE_HANDLE",
  "Custom SQL Query"."ACTUAL_PARLAY_HANDLE" AS "ACTUAL_PARLAY_HANDLE",
  "Custom SQL Query"."ACTUAL_PRE_HANDLE" AS "ACTUAL_PRE_HANDLE",
  "Custom SQL Query"."ACTUAL_SGP_HANDLE" AS "ACTUAL_SGP_HANDLE",
  "Custom SQL Query"."ACTUAL_STRAIGHTS_HANDLE" AS "ACTUAL_STRAIGHTS_HANDLE",
  "Custom SQL Query"."CURRENT_WEEK_FLAG" AS "CURRENT_WEEK_FLAG",
  "Custom SQL Query"."DAILY_100_PERC_CHECK" AS "DAILY_100_PERC_CHECK",
  "Custom SQL Query"."DAILY_NFL_HANDLE_PERC" AS "DAILY_NFL_HANDLE_PERC",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_DATE" AS "EVENT_DATE",
  "Custom SQL Query"."EVENT_NAME" AS "EVENT_NAME",
  "Custom SQL Query"."EVENT_TIME_ALK" AS "EVENT_TIME_ALK",
  "Custom SQL Query"."FORECAST_HANDLE" AS "FORECAST_HANDLE",
  "Custom SQL Query"."FORECAST_LIVE_HANDLE" AS "FORECAST_LIVE_HANDLE",
  "Custom SQL Query"."FORECAST_PARLAY_HANDLE" AS "FORECAST_PARLAY_HANDLE",
  "Custom SQL Query"."FORECAST_PRE_HANDLE" AS "FORECAST_PRE_HANDLE",
  "Custom SQL Query"."FORECAST_SGP_HANDLE" AS "FORECAST_SGP_HANDLE",
  "Custom SQL Query"."FORECAST_TW_FLAT" AS "FORECAST_TW_FLAT",
  "Custom SQL Query"."GAME_TYPE" AS "GAME_TYPE",
  "Custom SQL Query"."STRAIGHTS_FORECAST_HANDLE" AS "STRAIGHTS_FORECAST_HANDLE",
  "Custom SQL Query"."WEEK" AS "WEEK",
  "Custom SQL Query"."WEEK_END_DATE" AS "WEEK_END_DATE",
  "Custom SQL Query"."WEEK_START_DATE" AS "WEEK_START_DATE"
FROM (
  // forecast nfl 
  
  
  SELECT
    *
  FROM
    fbg_analytics_Dev.Andrew_mcmahon.NFL_EVENT_FORECASTS FC
  
    LEFT JOIN (SELECT
  CONCAT(SPLIT_PART(event, ' v ', 2), ' @ ', SPLIT_PART(event, ' v ', 1)) as EVENT_name,
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) AS event_DATE,
  case when DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', current_timestamp)) between egw.week_start_date and egw.week_end_date then 1 else 0 end current_week_flag,
  SUM(CASE WHEN BET_TYPE = 'SINGLE' THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_STRAIGHTS_HANDLE,
  SUM(CASE WHEN build_a_bet = FALSE and BET_TYPE <> 'SINGLE' THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_PARLAY_HANDLE,
  SUM(CASE WHEN build_a_bet = TRUE THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_SGP_HANDLE,
  SUM(total_stake/num_lines) AS ACTUAL_HANDLE,
  SUM(CASE WHEN LIVE_BET = 1 THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_LIVE_HANDLE,
  SUM(CASE WHEN LIVE_BET = FALSE THEN total_stake/num_lines ELSE 0 END) AS ACTUAL_PRE_HANDLE,
  egw.week_start_date,
  egw.week_end_date,
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) event_time_alk
  
  
  
  
  
  
  FROM
  
  
  fbg_source.osb_source.bets inner join fbg_source.osb_source.bet_parts on (bets.id = bet_parts.bet_id)
                             inner join fbg_source.osb_source.accounts on (bets.acco_id = accounts.id) 
                             left outer join fbg_analytics.trading.football_game_weeks_ egw on DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) between egw.week_start_date and egw.week_end_date and case when lower(bet_parts.comp) like '%nfl%' then 1 when lower(bet_parts.comp) like '%ncaa%' then 2 else 0 end = egw.comp_join_flag
                             
                             
  
  WHERE
  
  accounts.test = 0
  and
  lower(bet_parts.sport) = 'american_football'
  and
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
  bets.channel = 'INTERNET'
  
  GROUP BY
  
  ALL) sb on FC.EVENT = SB.EVENT_name and fc.Date = sb.event_time_alk
  
  WHERE FC.WEEK IS NOT NULL
  and GAME_TYPE != 'Other'
) "Custom SQL Query"
