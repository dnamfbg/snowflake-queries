-- Query ID: 01c39a3c-0212-6cb9-24dd-070319428ac7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SER_M_WH
-- Executed: 2026-04-09T22:20:57.300000+00:00
-- Elapsed: 23614ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_PRICE" AS "BET_PRICE",
  "Custom SQL Query"."BET_TYPEE" AS "BET_TYPEE",
  "Custom SQL Query"."BET_TYPE" AS "BET_TYPE",
  "Custom SQL Query"."CASHED_OUT_FLAG" AS "CASHED_OUT_FLAG",
  "Custom SQL Query"."COMP" AS "COMP",
  "Custom SQL Query"."CURRENT_TIMESTAMP_NY" AS "CURRENT_TIMESTAMP_NY",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_END_TIME" AS "EVENT_END_TIME",
  "Custom SQL Query"."EVENT_TIME_ET" AS "EVENT_TIME_ET",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."FREE_BET_HANDLE" AS "FREE_BET_HANDLE",
  "Custom SQL Query"."LEG_PRICE" AS "LEG_PRICE",
  "Custom SQL Query"."LEG_RESULT" AS "LEG_RESULT",
  "Custom SQL Query"."LIVE_BET" AS "LIVE_BET",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."MAX_EVENT_TIME_ET" AS "MAX_EVENT_TIME_ET",
  "Custom SQL Query"."NODE_ID" AS "NODE_ID",
  "Custom SQL Query"."NUM_LINES" AS "NUM_LINES",
  "Custom SQL Query"."PLACED_TIME_ET" AS "PLACED_TIME_ET",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SETTLEMENT_TIME_ET" AS "SETTLEMENT_TIME_ET",
  "Custom SQL Query"."SPORT" AS "SPORT",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."TOTAL_HANDLE" AS "TOTAL_HANDLE",
  "Custom SQL Query"."TOTAL_PAYOUT" AS "TOTAL_PAYOUT",
  "Custom SQL Query"."USERNAME" AS "USERNAME"
FROM (
  WITH
  
  accepted_bets
  
  as
  
  (
  
  select
  
  
  bet_parts.bet_id,
  
  bets.status,
  live_bet,
  accounts.username,
  bets.acco_id,
  CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time) placed_time_et,
  CONVERT_TIMEZONE('UTC','America/New_York', bets.settlement_time) settlement_time_et,
  jurisdiction_code state,
  sport,
  comp,
  event,
  node_id,
  market,
  case when build_a_bet = TRUE then 'SGP' when bet_type = 'SINGLE' then bet_type else 'PARLAY' end bet_type,
  selection,
  case when result = 4 then 1 else 0 end cashed_out_flag,
  case when build_a_bet = TRUE then 'SGP' when bet_type = 'SINGLE' then bet_type else 'PARLAY' end bet_typee,
  num_lines,
  bet_parts.price leg_price,
  bets.total_price bet_price,
  CASE
      WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
      ELSE bets.FREE_BET
  END as free_bet, -- fortuna
  result_type leg_result,
  CONVERT_TIMEZONE('UTC','America/New_York', bet_parts.event_time) event_time_et,
  CONVERT_TIMEZONE('UTC',
  'America/New_York',
  TO_TIMESTAMP(
  PARSE_JSON(e.summmary) :EventResult:finishTime::string
  )
  ) event_end_time,
  --case when free_bet = TRUE then total_stake/num_lines else 0 end free_bet_handle,
  case when 
          (case WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
                ELSE bets.FREE_BET
           END) = TRUE 
       then 
          (CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0)
              ELSE bets.total_stake
           END ) 
      / num_lines else 0 end free_bet_handle,
      
  --total_stake/num_lines total_handle,
  (CASE
      WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0)
      ELSE bets.total_stake
  END) / num_lines as total_handle,
  payout/num_lines total_payout
  
  from
  
  fbg_source.osb_source.bet_parts inner join fbg_source.osb_source.bets on bet_parts.bet_id = bets.id
  inner join fbg_source.osb_source.accounts on bets.acco_id = accounts.id
  left outer join fbg_source.osb_source.event_results e on bet_parts.node_id = e.event_id
  left outer join fbg_source.osb_source.jurisdictions on bets.jurisdictions_id = jurisdictions.id
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa ON bets.id = sfsa.bet_id
  
  where
  
  --DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) >= DATEADD('days', -3, current_date())
  --and
  bets.status = 'ACCEPTED'
  and
  accounts.test = 0
  and 
  CASE
        WHEN
          bets.fancash_stake_amount > 0
          AND bets.FREE_BET = FALSE
          AND sfsa.bet_id IS NULL THEN 0
        ELSE 1 
      END = 1
  
  order by
  
  CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time) desc, bet_id desc
  
  ),
  
  add_timestamps
  
  as
  
  (
  
  select
  
  *,
  max(event_time_et) over (partition by bet_id) max_event_time_et,
  CONVERT_TIMEZONE('UTC','America/New_York', CURRENT_TIMESTAMP(2)) current_timestamp_ny
  
  from
  
  
  accepted_bets
  
  )
  
  select
  
  *
  
  from
  
  add_timestamps
  
  
  where
  
  max_event_time_et < current_timestamp_ny
) "Custom SQL Query"
