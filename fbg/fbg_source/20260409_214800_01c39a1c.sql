-- Query ID: 01c39a1c-0212-67a9-24dd-0703193b1933
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SER_L_WH_PROD
-- Executed: 2026-04-09T21:48:00.811000+00:00
-- Elapsed: 81283ms
-- Environment: FBG

SELECT "Custom SQL Query"."BONUS_HANDLE" AS "BONUS_HANDLE",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."CHANNEL" AS "CHANNEL",
  "Custom SQL Query"."COMP" AS "COMP",
  "Custom SQL Query"."COMP_JOIN_FLAG" AS "COMP_JOIN_FLAG",
  "Custom SQL Query"."COMP_WEEK_NAME" AS "COMP_WEEK_NAME",
  "Custom SQL Query"."CUSTOMERS" AS "CUSTOMERS",
  "Custom SQL Query"."CUSTOMERS_FIRST_DAY" AS "CUSTOMERS_FIRST_DAY",
  "Custom SQL Query"."DAY_OF_EVENT_WEEK" AS "DAY_OF_EVENT_WEEK",
  "Custom SQL Query"."EVENT_LATER_THAN_THIS_WEEK" AS "EVENT_LATER_THAN_THIS_WEEK",
  "Custom SQL Query"."HIGH_LEVEL_SEGMENT" AS "HIGH_LEVEL_SEGMENT",
  "Custom SQL Query"."HOUR_OF_PLACEMENT" AS "HOUR_OF_PLACEMENT",
  "Custom SQL Query"."MAX_PLACED_TIMESTAMP" AS "MAX_PLACED_TIMESTAMP",
  "Custom SQL Query"."SEASON" AS "SEASON",
  "Custom SQL Query"."SEASON_STAGE" AS "SEASON_STAGE",
  "Custom SQL Query"."SEASON_WEEK_NUMBER" AS "SEASON_WEEK_NUMBER",
  "Custom SQL Query"."STAGE_WEEK_NUMBER" AS "STAGE_WEEK_NUMBER",
  "Custom SQL Query"."TOTAL_BONUS_HANDLE" AS "TOTAL_BONUS_HANDLE",
  "Custom SQL Query"."TOTAL_CASH_HANDLE" AS "TOTAL_CASH_HANDLE",
  "Custom SQL Query"."WEEK_END_DATE" AS "WEEK_END_DATE",
  "Custom SQL Query"."WEEK_START_DATE" AS "WEEK_START_DATE"
FROM (
  WITH
  
  stage_1 AS (
      SELECT 
          egw.*,
          bets.acco_id,
          high_level_segment,
  
          CASE 
              WHEN DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) < week_start_date THEN week_start_date
              WHEN DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) > week_end_date THEN NULL
              ELSE date_trunc(hour, CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time))
          END AS day_of_event_week,
  
          hour(day_of_event_week) AS hour_of_placement,
          bets.channel,
          dayname(DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time))) AS daynameee,     
  
          -- Sum cash handle (FBG_SOURCE.OSB_SOURCE.BETS.FREE_BET = FALSE)
          SUM(
              CASE WHEN 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
                  AND bets.status <> 'VOID' 
              THEN 
                  (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines
              ELSE 0 END
          ) AS cash_handle,
  
          -- Also sum for total_cash_handle (same as above)
          SUM(
              CASE WHEN 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
                  AND bets.status <> 'VOID' 
              THEN 
                  (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines
              ELSE 0 END
          ) AS total_cash_handle,
  
          -- Sum bonus_handle (FBG_SOURCE.OSB_SOURCE.BETS.FREE_BET = TRUE)
          SUM(
              CASE WHEN 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = TRUE 
                  AND bets.status <> 'VOID' 
              THEN 
                  (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines
              ELSE 0 END
          ) AS bonus_handle,
  
          -- total_bonus_handle (same as above)
          SUM(
              CASE WHEN 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = TRUE 
                  AND bets.status <> 'VOID' 
              THEN 
                  (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines
              ELSE 0 END
          ) AS total_bonus_handle,
  
          MAX(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) AS max_placed_time
  
      FROM 
          fbg_source.osb_source.bets 
          INNER JOIN fbg_source.osb_source.bet_parts ON (bets.id = bet_parts.bet_id)
          INNER JOIN fbg_source.osb_source.accounts ON (bets.acco_id = accounts.id) 
          LEFT OUTER JOIN fbg_analytics.trading.nba_game_weeks_ egw ON 
              DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time)) BETWEEN egw.week_start_date AND egw.week_end_date 
              AND CASE WHEN lower(bet_parts.comp) like '%nba%' THEN 1 ELSE 0 END = egw.comp_join_flag
          LEFT OUTER JOIN fbg_analytics.trading.fct_value_bands ON (bets.acco_id = fct_value_bands.acco_id)
          LEFT OUTER JOIN fbg_analytics.trading.market_definitions md ON bet_parts.mrkt_type = md.market_type
          -- ADDITION: join for Fancash logic
          LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa ON bets.id = sfsa.bet_id
  
      WHERE
          accounts.test = 0
          AND
          CASE WHEN lower(bet_parts.comp) like '%nba%' AND DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time))  BETWEEN '2023-10-05' AND '2024-06-23' THEN 1
               WHEN lower(bet_parts.comp) like '%nba%' AND DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time))  BETWEEN '2024-10-04' AND '2025-06-22' THEN 1
               WHEN lower(bet_parts.comp) like '%nba%' AND DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bet_parts.event_time))  BETWEEN '2025-10-03' AND '2026-03-01' THEN 1
               ELSE 0 END = 1
          AND
          lower(sport) = 'basketball'
          AND
          CASE WHEN lower(bet_parts.comp) like '%wnba%' THEN 0
               WHEN lower(bet_parts.comp) like '%nba%' THEN 1 ELSE 0 END = 1
          AND
          bets.status <> 'REJECTED'
          AND
          lower(tier1_group) NOT LIKE '%future%'
          AND
          bets.channel = 'INTERNET'
  
      GROUP BY ALL
  ),
  
  stage_2 AS (
      SELECT
          *,
          min(day_of_event_week) OVER (PARTITION BY acco_id, comp_join_flag, comp_week_name) AS first_date_of_week,
          max(max_placed_time) OVER (PARTITION BY 1) AS max_placed_timestamp
      FROM stage_1
  ),
  
  stage_3 AS (
      SELECT
          comp,
          comp_join_flag,
          season_stage,
          season,
          season_week_number,
          stage_week_number,
          comp_week_name,
          week_start_date,
          week_end_date,
          CASE WHEN DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', current_timestamp)) >= week_start_date THEN 0 ELSE 1 END AS event_later_than_this_week,
          high_level_segment,
          day_of_event_week,
          hour_of_placement,
          channel,
          max_placed_timestamp,
          sum(cash_handle) AS cash_handle,
          sum(total_cash_handle) AS total_cash_handle,
          sum(bonus_handle) AS bonus_handle,
          sum(total_bonus_handle) AS total_bonus_handle,
          count(distinct CASE WHEN channel = 'INTERENT' THEN acco_id END) AS customers,
          count(distinct CASE WHEN channel = 'INTERNET' AND first_date_of_week = day_of_event_week THEN acco_id END) AS customers_first_day
  
      FROM stage_2
  
      GROUP BY ALL
  )
  
  SELECT * FROM stage_3
) "Custom SQL Query"
