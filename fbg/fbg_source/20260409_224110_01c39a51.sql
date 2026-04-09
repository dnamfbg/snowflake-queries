-- Query ID: 01c39a51-0212-6dbe-24dd-07031946cd8b
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Last Executed: 2026-04-09T22:41:10.722000+00:00
-- Elapsed: 206332ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."AVC" AS "AVC",
  "Custom SQL Query"."AVC_MINUSTOTALHANDLE" AS "AVC_MINUSTOTALHANDLE",
  "Custom SQL Query"."BETS_PARLAYS" AS "BETS_PARLAYS",
  "Custom SQL Query"."BETS_SGP" AS "BETS_SGP",
  "Custom SQL Query"."CASH_BETS_PARLAYS" AS "CASH_BETS_PARLAYS",
  "Custom SQL Query"."CASH_BETS_SGP" AS "CASH_BETS_SGP",
  "Custom SQL Query"."CHANNEL" AS "CHANNEL",
  "Custom SQL Query"."COMP" AS "COMP",
  "Custom SQL Query"."EVENTRANK" AS "EVENTRANK",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_TIME" AS "EVENT_TIME",
  "Custom SQL Query"."INSTRUMENT_ID" AS "INSTRUMENT_ID",
  "Custom SQL Query"."JOINFLAG" AS "JOINFLAG",
  "Custom SQL Query"."JURISDICTIONS_ID" AS "JURISDICTIONS_ID",
  "Custom SQL Query"."JURISDICTION_NAME" AS "JURISDICTION_NAME",
  "Custom SQL Query"."LAST_TO_RUN_HANDLE_RUNNING_THROUGH_SELECTION" AS "LAST_TO_RUN_HANDLE_RUNNING_THROUGH_SELECTION",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."MARKET_BOOST_FLAG" AS "MARKET_BOOST_FLAG",
  "Custom SQL Query"."MARKET_ID" AS "MARKET_ID",
  "Custom SQL Query"."MARK_ID_TOTAL_BET_CASH_HANDLE_SINGLE" AS "MARK_ID_TOTAL_BET_CASH_HANDLE_SINGLE",
  "Custom SQL Query"."MAX_TIMESTAMP" AS "MAX_TIMESTAMP",
  "Custom SQL Query"."MRKT_TYPE" AS "MRKT_TYPE",
  "Custom SQL Query"."NEXT_TO_RUN_HANDLE_RUNNING_THROUGH_SELECTION" AS "NEXT_TO_RUN_HANDLE_RUNNING_THROUGH_SELECTION",
  "Custom SQL Query"."NODE_ID" AS "NODE_ID",
  "Custom SQL Query"."OPEN_CASH_BETS" AS "OPEN_CASH_BETS",
  "Custom SQL Query"."ORIGINAL_BET_STAKE_LAST_TO_RUN" AS "ORIGINAL_BET_STAKE_LAST_TO_RUN",
  "Custom SQL Query"."ORIGINAL_BET_STAKE_NEXT_TO_RUN" AS "ORIGINAL_BET_STAKE_NEXT_TO_RUN",
  "Custom SQL Query"."OTHER_SPREAD_LAST_TO_RUN_LIABILITY" AS "OTHER_SPREAD_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."O_PARLAY_CASH_HANDLE" AS "O_PARLAY_CASH_HANDLE",
  "Custom SQL Query"."O_PARLAY_HANDLE" AS "O_PARLAY_HANDLE",
  "Custom SQL Query"."O_SGP_CASH_HANDLE" AS "O_SGP_CASH_HANDLE",
  "Custom SQL Query"."O_SGP_HANDLE" AS "O_SGP_HANDLE",
  "Custom SQL Query"."PARLAY_BETS" AS "PARLAY_BETS",
  "Custom SQL Query"."PARLAY_BONUS_LAST_TO_RUN_LIABILITY" AS "PARLAY_BONUS_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."PARLAY_BONUS_PAYOUT_IF_SELECTION_WINS" AS "PARLAY_BONUS_PAYOUT_IF_SELECTION_WINS",
  "Custom SQL Query"."PARLAY_CASH_BETS" AS "PARLAY_CASH_BETS",
  "Custom SQL Query"."PARLAY_CASH_HANDLE" AS "PARLAY_CASH_HANDLE",
  "Custom SQL Query"."PARLAY_CASH_HANDLE_BET" AS "PARLAY_CASH_HANDLE_BET",
  "Custom SQL Query"."PARLAY_CASH_LAST_TO_RUN_LIABILITY" AS "PARLAY_CASH_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."PARLAY_CASH_PAYOUT_IF_SELECTION_WINS" AS "PARLAY_CASH_PAYOUT_IF_SELECTION_WINS",
  "Custom SQL Query"."PARLAY_HANDLE" AS "PARLAY_HANDLE",
  "Custom SQL Query"."PARLAY_HANDLE_BET" AS "PARLAY_HANDLE_BET",
  "Custom SQL Query"."PARLAY_LAST_TO_RUN_LIABILITY" AS "PARLAY_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."PARLAY_PAYOUT_IF_SELECTION_WINS" AS "PARLAY_PAYOUT_IF_SELECTION_WINS",
  "Custom SQL Query"."PARLAY_RUNNING_UP_DOLLARS" AS "PARLAY_RUNNING_UP_DOLLARS",
  "Custom SQL Query"."PARLAY_RUNNING_UP_DOLLARS_IF_SELECTION_WINS" AS "PARLAY_RUNNING_UP_DOLLARS_IF_SELECTION_WINS",
  "Custom SQL Query"."PARLAY_RUNNING_UP_DOLLARS_LAST_TO_RUN" AS "PARLAY_RUNNING_UP_DOLLARS_LAST_TO_RUN",
  "Custom SQL Query"."PARLAY_RUNNING_UP_DOLLARS_NEXT_TO_RUN" AS "PARLAY_RUNNING_UP_DOLLARS_NEXT_TO_RUN",
  "Custom SQL Query"."RANKK" AS "RANKK",
  "Custom SQL Query"."RETAIL_VENUE_ID" AS "RETAIL_VENUE_ID",
  "Custom SQL Query"."RETAIL_VENUE_NAME" AS "RETAIL_VENUE_NAME",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SELECTION_NOT_RESULTED" AS "SELECTION_NOT_RESULTED",
  "Custom SQL Query"."SELECTION_TOTAL_LAST_TO_RUN_LIABILITY" AS "SELECTION_TOTAL_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."SEL" AS "SEL",
  "Custom SQL Query"."SGP_BETS" AS "SGP_BETS",
  "Custom SQL Query"."SGP_BETS_EVENT" AS "SGP_BETS_EVENT",
  "Custom SQL Query"."SGP_CASH_BETS" AS "SGP_CASH_BETS",
  "Custom SQL Query"."SGP_CASH_BETS_EVENT" AS "SGP_CASH_BETS_EVENT",
  "Custom SQL Query"."SGP_HANDLE_EVENT" AS "SGP_HANDLE_EVENT",
  "Custom SQL Query"."SINGLES_CASH_HANDLE" AS "SINGLES_CASH_HANDLE",
  "Custom SQL Query"."SINGLES_HANDLE" AS "SINGLES_HANDLE",
  "Custom SQL Query"."SINGLES_LIABILITY" AS "SINGLES_LIABILITY",
  "Custom SQL Query"."SINGLES_LIABILITY_CASH" AS "SINGLES_LIABILITY_CASH",
  "Custom SQL Query"."SINGLES_POTENTIAL_PAYOUT" AS "SINGLES_POTENTIAL_PAYOUT",
  "Custom SQL Query"."SINGLES_POTENTIAL_PAYOUT_CASH" AS "SINGLES_POTENTIAL_PAYOUT_CASH",
  "Custom SQL Query"."SINGLE_BETS" AS "SINGLE_BETS",
  "Custom SQL Query"."SIX_BOX_FLAG" AS "SIX_BOX_FLAG",
  "Custom SQL Query"."SIX_BOX_MARKET" AS "SIX_BOX_MARKET",
  "Custom SQL Query"."SPORT" AS "SPORT",
  "Custom SQL Query"."SPRD_AND_LOSE_LAST_TO_RUN_LIABILITY" AS "SPRD_AND_LOSE_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."SPRD_AND_WIN_LAST_TO_RUN_LIABILITY" AS "SPRD_AND_WIN_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."TOTAL_BET_PARLAY_CASH_HANDLE" AS "TOTAL_BET_PARLAY_CASH_HANDLE",
  "Custom SQL Query"."TOTAL_BET_PARLAY_CASH_HANDLE_PROPORTIONAL" AS "TOTAL_BET_PARLAY_CASH_HANDLE_PROPORTIONAL",
  "Custom SQL Query"."TOTAL_BET_PARLAY_HANDLE" AS "TOTAL_BET_PARLAY_HANDLE",
  "Custom SQL Query"."TOTAL_BET_PARLAY_HANDLE_PROPORTIONAL" AS "TOTAL_BET_PARLAY_HANDLE_PROPORTIONAL",
  "Custom SQL Query"."TOTAL_CASH_HANDLE_BET_EXCL_SGP" AS "TOTAL_CASH_HANDLE_BET_EXCL_SGP",
  "Custom SQL Query"."TOTAL_CASH_HANDLE_BET_SGP" AS "TOTAL_CASH_HANDLE_BET_SGP",
  "Custom SQL Query"."TOTAL_CASH_HANDLE_EXCL_SGP" AS "TOTAL_CASH_HANDLE_EXCL_SGP",
  "Custom SQL Query"."TOTAL_CASH_HANDLE_SGP" AS "TOTAL_CASH_HANDLE_SGP",
  "Custom SQL Query"."TOTAL_HANDLE_BET_EXCL_SGP" AS "TOTAL_HANDLE_BET_EXCL_SGP",
  "Custom SQL Query"."TOTAL_HANDLE_BET_SGP" AS "TOTAL_HANDLE_BET_SGP",
  "Custom SQL Query"."TOTAL_HANDLE_EXCL_SGP" AS "TOTAL_HANDLE_EXCL_SGP",
  "Custom SQL Query"."TOTAL_HANDLE_SGP" AS "TOTAL_HANDLE_SGP",
  "Custom SQL Query"."TOTAL_LAST_TO_RUN_LIABILITY2" AS "TOTAL_LAST_TO_RUN_LIABILITY2",
  "Custom SQL Query"."TOTAL_LAST_TO_RUN_LIABILITY" AS "TOTAL_LAST_TO_RUN_LIABILITY",
  "Custom SQL Query"."WINNERCAT" AS "WINNERCAT"
FROM (
  with 
  
  marketdefinitions AS (
  
      SELECT
  
          market_type,
          max(
          case when market_type IN (
          'AMERICAN_FOOTBALL:4Q:BTS',
          'AMERICAN_FOOTBALL:3Q:TDOU',
          'AMERICAN_FOOTBALL:FT:PROPRSPRCYDS',
          'AMERICAN_FOOTBALL:P:B:FGOU',
          'AMERICAN_FOOTBALL:P:OU',
          'AMERICAN_FOOTBALL:FTOT:A:SCKOU',
          'AMERICAN_FOOTBALL:FTOT:B:SCKOU',
          'AMERICAN_FOOTBALL:FTOT:A:TDOU',
          'AMERICAN_FOOTBALL:P:A:FGOU',
          'AMERICAN_FOOTBALL:FT:PROPRSATT',
          'AMERICAN_FOOTBALL:FTOT:ETTSXP',
          'AMERICAN_FOOTBALL:FTOT:A:FGOU',
          'AMERICAN_FOOTBALL:FT:PROPATD',
          'AMERICAN_FOOTBALL:P:TDOU',
          'AMERICAN_FOOTBALL:1H:B:FGOU',
          'AMERICAN_FOOTBALL:FTOT:B:FGOU',
          'AMERICAN_FOOTBALL:POT:OU',
          'AMERICAN_FOOTBALL:FT:PROPREC',
          'AMERICAN_FOOTBALL:FTOT:B:TDOU',
          'AMERICAN_FOOTBALL:2H:A:FGOU',
          'AMERICAN_FOOTBALL:2H:B:FGOU',
          'AMERICAN_FOOTBALL:FT:PROPPSYDS',
          'AMERICAN_FOOTBALL:P:B:TDOU',
          'AMERICAN_FOOTBALL:2H:A:TDOU',
          'AMERICAN_FOOTBALL:P:FGOU',
          'AMERICAN_FOOTBALL:P:BTS',
          'AMERICAN_FOOTBALL:FT:PROPSCMGYDS',
          'AMERICAN_FOOTBALL:FT:PROPRSTD',
          'AMERICAN_FOOTBALL:3Q:BTS',
          'AMERICAN_FOOTBALL:1Q:BTS',
          'AMERICAN_FOOTBALL:2H:FGOU',
          'AMERICAN_FOOTBALL:2Q:BTS',
          'AMERICAN_FOOTBALL:FT:PROPPSCMP',
          'AMERICAN_FOOTBALL:FTOT:A:OU',
          'AMERICAN_FOOTBALL:P:A:OU',
          'AMERICAN_FOOTBALL:1H:A:TDOU',
          'AMERICAN_FOOTBALL:2H:B:TDOU',
          'AMERICAN_FOOTBALL:1H:TDOU',
          'AMERICAN_FOOTBALL:P:DNB',
          'AMERICAN_FOOTBALL:FTOT:B:OU',
          'AMERICAN_FOOTBALL:1Q:TDOU',
          'AMERICAN_FOOTBALL:FT:PROPPSATT',
          'AMERICAN_FOOTBALL:FT:PROPPSPRSYDS',
          'AMERICAN_FOOTBALL:FT:PROPRSYDS',
          'AMERICAN_FOOTBALL:P:A:TDOU',
          'AMERICAN_FOOTBALL:FTOT:FGM',
          'AMERICAN_FOOTBALL:FT:PROPRCYDS',
          'AMERICAN_FOOTBALL:1H:B:TDOU',
          'AMERICAN_FOOTBALL:P:SPRD',
          'AMERICAN_FOOTBALL:FTOT:OU',
          'AMERICAN_FOOTBALL:FTOT:TD',
          'AMERICAN_FOOTBALL:POT:DNB',
          'AMERICAN_FOOTBALL:FT:PROPPSTD',
          'AMERICAN_FOOTBALL:P:B:OU',
          'AMERICAN_FOOTBALL:1H:A:FGOU',
          'AMERICAN_FOOTBALL:2H:TDOU',
          'AMERICAN_FOOTBALL:FT:PROPRCTD',
          'AMERICAN_FOOTBALL:1H:FGOU'
          ) then 'ONE'
          else
          winner_category end) winner_category
      
      FROM 
      
      
          fbg_analytics.trading.market_definitions
      
      
      GROUP BY
          ALL
  ),
  
  timestamp AS
  
  (
      SELECT
  
          1 joinflag,
          max(greatest(CONVERT_TIMEZONE('UTC','America/New_York', bets.settlement_time),CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time))) max_timestamp
  
      FROM
  
          fbg_source.osb_source.bets
  
      WHERE
  
          CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time) >= current_date - 4 
  
      GROUP BY
          ALL
  
  ),
  
  event_info AS (
  
  
      select
      
          instrument_id AS sel_id,
          MAX(CONVERT_TIMEZONE('UTC','America/New_York', event_time)) event_time_et,
          MAX(event) event_name,
          max(comp) comp,
          max(market) market,
          max(sport) sport
  
      
      
      
      from
          FBG_SOURCE.OSB_SOURCE.bet_parts 
      inner join
          FBG_SOURCE.OSB_SOURCE.bets
          on (bet_parts.bet_id = bets.id)
      inner join
          FBG_SOURCE.OSB_SOURCE.accounts
          on (bets.acco_id = accounts.id)
  
      WHERE
      
      
          bets.status = 'ACCEPTED'
          and
          accounts.test = 0 
          AND 
          bets.pointsbet_bet_id is NULL
          and
          teaser_price is null
  
      
      
      
      GROUP BY
          ALL
  
  ),
  
  boost_percentage AS (
  
      SELECT
          id, 
          (parse_json(data):Bonus:oddsBoost:boostPercentage)/100 boost_percentage  
      FROM 
          fbg_source.osb_source.bonus_campaigns   t
      WHERE
          t.DATA ILIKE '%boostPercentage%'
  
  ),
  
  
  stack_stage AS (
  
  
      SELECT
      
          bet_id,
          node_id,
          instrument_id,
          bets.channel,
          bets.jurisdictions_id,
          COALESCE(accounts.retail_venue_id,0) retail_venue_id,
          count(distinct node_id) over (partition by bet_id) eventsinbet,
          count(distinct instrument_id) over (partition by node_id, bet_id) selsonevent
      
      
      FROM
          FBG_SOURCE.OSB_SOURCE.bet_parts 
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.bets
          ON (bet_parts.bet_id = bets.id)
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.accounts
          ON (bets.acco_id = accounts.id)
      
      where
      
      
      bets.status = 'ACCEPTED'
      and
      teaser_price is null
      AND
      build_a_bet = TRUE
  ),
  
  stack_legs AS (
  
      SELECT
  
      DISTINCT
          bet_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          instrument_id
  
      FROM
  
          stack_stage
  
      WHERE
  
          eventsinbet > 1
          AND
          selsonevent = 1
  ),
  
  winning_prices_stage AS(
  
  
  SELECT
      bet_parts.bet_id,
      max(bets.jurisdictions_id) AS jurisdictions_id,
      max(bets.channel) AS channel,
      max(COALESCE(accounts.retail_venue_id,0)) AS retail_venue_id,
      max(total_price) AS bet_price,
      max(build_a_bet) AS sgp_flag,
      max(CASE WHEN stack_legs.instrument_id IS NOT NULL THEN 1 ELSE 0 END) AS stack_flag,
      max(boost_percentage) AS boost_percentage,
      max(
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
              THEN TRUE ELSE bets.FREE_BET END
      ) AS free_bet,
      count(DISTINCT bet_parts.instrument_id) AS legs,
      count(DISTINCT stack_legs.instrument_id) AS stacklegs,
      max(num_lines) AS num_lines,
      count(DISTINCT CASE WHEN result_type IN ('PUSH','VOID','WIN') THEN bet_parts.instrument_id END) AS resulted_legs,
      count(DISTINCT CASE WHEN result_type IN ('PUSH','VOID','WIN') THEN stack_legs.instrument_id END) AS resulted_stack_legs,
      EXP(SUM(LN(CASE WHEN result_type IN ('PUSH','VOID') THEN 1 ELSE price END))) AS max_price,
      EXP(SUM(LN(CASE WHEN result_type IN ('WIN') THEN price ELSE 1 END))) AS winners_price
  
  FROM
      FBG_SOURCE.OSB_SOURCE.bet_parts 
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.bets
      ON (bet_parts.bet_id = bets.id)
  LEFT OUTER JOIN
      fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa
      ON bets.id = sfsa.bet_id
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.accounts
      ON (bets.acco_id = accounts.id)
  LEFT JOIN
      boost_percentage
      ON bets.bonus_campaign_id = boost_percentage.id
  LEFT JOIN
      stack_legs
      ON bet_parts.bet_id = stack_legs.bet_id AND bet_parts.instrument_id = stack_legs.instrument_id
  
  WHERE
      bets.status = 'ACCEPTED'
      AND teaser_price IS NULL
      AND bet_type != 'SINGLE'
      AND accounts.test = 0
      AND CASE 
              WHEN bets.fancash_stake_amount > 0
              AND bets.FREE_BET = FALSE
              AND sfsa.bet_id IS NULL THEN 0
              ELSE 1 
          END = 1
  
  GROUP BY
      bet_parts.bet_id
  
  
  ),
  
  winning_prices AS (
  
      SELECT
          *,
          legs-resulted_legs remaining_legs
  
      FROM
          winning_prices_stage
  
      WHERE
          CASE
              WHEN sgp_flag = FALSE then 1 
              when sgp_flag = TRUE and stack_flag = 1 and stacklegs = 1 and remaining_legs = 1 then 1 else 0
          end = 1
  ),
  
  multiples_run_up_stage_stage AS(
  
  
  SELECT
      bet_parts.bet_id,
      bets.channel,
      bets.jurisdictions_id,
      COALESCE(accounts.retail_venue_id,0) AS retail_venue_id,
      stack_flag,
      bet_price,
      boost_percentage,
      -- Use fancash logic for free_bet:
      CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END AS free_bet,
      instrument_id,
      market_id,
      selection,
      market,
      bet_parts.mrkt_type,
      -- Use fancash logic for stake:
      CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE stake END AS stake,
      price,
      legs,
      winning_prices.num_lines,
      resulted_legs,
      max_price,
      winners_price,
      remaining_legs,
      CASE WHEN result_type IN ('NOT_SET') THEN 1 ELSE 0 END AS not_resulted, 
      CASE WHEN not_resulted = 1 AND remaining_legs = 1 THEN 1 ELSE 0 END AS last_to_run,
      CASE WHEN not_resulted = 1 AND remaining_legs > 1 THEN 1 ELSE 0 END AS next_to_run,
      COALESCE(winner_category,'ONE') AS winnercat,
      SUM(
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE stake END
      ) OVER (PARTITION BY market_id, bets.channel, bets.jurisdictions_id, COALESCE(accounts.retail_venue_id,0)) AS parlay_market_handle_non_prop
  
  FROM
      FBG_SOURCE.OSB_SOURCE.BET_PARTS
  INNER JOIN
      winning_prices
      ON (bet_parts.bet_id = winning_prices.bet_id)
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.BETS
      ON (bet_parts.bet_id = bets.id)
  LEFT OUTER JOIN
      fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa
      ON bets.id = sfsa.bet_id
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.accounts
      ON (bets.acco_id = accounts.id)        
  LEFT OUTER JOIN
      marketdefinitions md
      ON bet_parts.mrkt_type = md.market_type
  
  WHERE
      bets.STATUS = 'ACCEPTED'
      AND CASE 
              WHEN bets.fancash_stake_amount > 0
              AND bets.FREE_BET = FALSE
              AND sfsa.bet_id IS NULL THEN 0
              ELSE 1 
          END = 1
  
  ),
  
  multiple_market_handle AS (
  
  
      SELECT
          market_id as marketid_,
          channel,
          jurisdictions_id,
          retail_venue_id,
          max(case when lower(winnercat) <> 'one' then parlay_market_handle_non_prop else 0 end) market_channel_handle
  
      FROM
          multiples_run_up_stage_stage
  
      GROUP BY
          ALL
      
  
  ),
  
  multiples_run_ups_stage AS (
  
      select
      
          instrument_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          max(case when free_bet = FALSE then last_to_run else 0 end) last_to_run_flag,
          max(market_id) marketid,
          max(not_resulted) not_resulted,
          max(selection)selection,
          max(market)market,
          max(mrkt_type)mrkt_type,
          sum(case when free_bet = FALSE then stake else 0 end) total_bet_parlay_cash_handle,
          sum(stake) total_bet_parlay_handle,
          sum(case when free_bet = FALSE then stake/num_lines else 0 end) total_bet_parlay_cash_handle_proportional,
          sum(stake/num_lines) total_bet_parlay_handle_proportional,
          sum(case when not_resulted = 1 and stack_flag = 0 then winners_price * stake else 0 end) running_up_dollars,
          sum(case when not_resulted = 1 and next_to_run = 1 then stake else 0 end) original_bet_stake_next_to_run,
          sum(case when not_resulted = 1 and last_to_run = 1 then stake else 0 end) original_bet_stake_last_to_run,
          sum(case when not_resulted = 1 and next_to_run = 1 and stack_flag = 0 then winners_price * stake else 0 end) running_up_dollars_next_to_run,
          sum(case when not_resulted = 1 and next_to_run = 1 and stack_flag = 0 then winners_price * stake * price - case when free_bet = TRUE then stake else 0 end else 0 end) running_up_dollars_if_selection_wins,
          sum(case when not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then winners_price * stake else 0 end) running_up_dollars_last_to_run,
          sum(case when not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake - case when free_bet = TRUE then stake else 0 end
                   when not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price  - case when free_bet = TRUE then stake else 0 end
          else 0 end) parlay_payout_if_selection_wins,
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) = 'one' then stake else 0 end) 
          +
          max(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) <> 'one' then parlay_market_handle_non_prop else 0 end) 
          - 
          sum(case when not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake - case when free_bet = TRUE then stake else 0 end
                   when not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price  - case when free_bet = TRUE then stake else 0 end
          else 0 end)  parlay_last_to_run_liability,
          
          
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake
                   when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price 
          else 0 end) parlay_cash_payout_if_selection_wins,
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) = 'one' then stake else 0 end) 
          +
          max(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) <> 'one' then parlay_market_handle_non_prop else 0 end) 
          - 
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake
                   when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price 
          else 0 end)  parlay_cash_last_to_run_liability,
          
          
          
          sum(case when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake
                   when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price 
          else 0 end) parlay_bonus_payout_if_selection_wins,
          sum(case when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake
                   when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * bet_price 
          else 0 end*-1)  parlay_bonus_last_to_run_liability
      
      FROM
      
          multiples_run_up_stage_stage
      
      GROUP BY
          ALL
  
  
  ),
  
  multiples_run_ups AS (
  
      select
      
          *,
          max(last_to_run_flag) over (partition by instrument_id) last_to_run_sel
      
      from
      
      
          multiples_run_ups_stage
      
      where
      
          not_resulted = 1
      
      order by 
      
          parlay_payout_if_selection_wins desc
  ),        
  
  multiple_last_to_run AS (
  
      SELECT
          instrument_id,
          max(last_to_run_sel) lasttorunsel
  
      FROM
          multiples_run_ups
  
      GROUP BY
          ALL
  
  
       
  ),
  
  singles_book_stage_stage AS (
  
  
  SELECT
      instrument_id,
      bets.channel,
      bets.jurisdictions_id,
      COALESCE(accounts.retail_venue_id,0) retail_venue_id,
      max(event_name) event_name,
      max(event_time_et) event_time_et,
      max(coalesce(winner_category,'ONE')) winnercat,
      max(case when event_info.comp ILIKE '%boost%' then 1
               when event_info.Market ILIKE '%boost%' then 1  
               when Mrkt_Type ILIKE '%boost%' THEN 1 else 0 end) market_boost_flag,
      MAX(CASE WHEN instruments.result IS NULL THEN 1 
               WHEN instruments.result IN ('NOT_SET') THEN 1 ELSE 0 END) selection_not_resulted,
      MAX(market_id) market_id,
      MAX(node_id) node_id,
      MAX(event_info.COMP) COMP,
      MAX(event_info.SPORT) SPORT,
      max(selection) selection,
      max(MRkt_TYPE) mrkt_type,
      max(event_info.market) market,
      count(distinct case when bet_type = 'SINGLE' then bet_parts.bet_id end ) single_bets,
      count(distinct case when bet_type = 'SINGLE' and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
      then bet_parts.bet_id end ) single_cash_bets,
      sum(case when bet_type = 'SINGLE' 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines 
          else 0 end) singles_handle,
      sum(case when 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          and bet_type = 'SINGLE' 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)/num_lines 
          else 0 end) singles_cash_handle,
  
      sum(case when bet_type = 'SINGLE' 
          then (((CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) * total_price)
              - CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
              * (1+COALESCE(boost_percentage,0))
              + (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
              - case when 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = TRUE
                then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
                else 0 end
          else 0 end) singles_potential_payout,
  
      sum(case when 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = TRUE 
          then 0 
          when bet_type = 'SINGLE' 
          then (((CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) * total_price)
              - (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END))
              * (1+COALESCE(boost_percentage,0))
              + (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
              - case when 
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = TRUE
                then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
                else 0 end
          else 0 end) singles_potential_payout_cash,
      
      SUM(case when build_a_bet = FALSE 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS total_handle_excl_sgp,
      SUM(case when build_a_bet = FALSE 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS total_handle_bet_excl_sgp,
      SUM(case when build_a_bet = FALSE and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS total_cash_handle_excl_sgp,
      SUM(case when build_a_bet = FALSE and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS total_cash_handle_bet_excl_sgp,
      
      SUM(case when build_a_bet = TRUE 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS total_handle_sgp,
      SUM(case when build_a_bet = TRUE 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS total_handle_bet_sgp,
      SUM(case when build_a_bet = TRUE and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS total_cash_handle_sgp,
      SUM(case when build_a_bet = TRUE and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS total_cash_handle_bet_sgp,
      
      SUM(case when build_a_bet = FALSE and bet_type <> 'SINGLE' 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS parlay_handle,
      SUM(case when build_a_bet = FALSE and bet_type <> 'SINGLE' 
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS parlay_handle_bet,
      SUM(case when build_a_bet = FALSE and bet_type <> 'SINGLE' and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / Num_Lines 
          else 0 end) AS parlay_cash_handle,
      SUM(case when build_a_bet = FALSE and bet_type <> 'SINGLE' and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)  
          else 0 end) AS parlay_cash_handle_bet,
      
      count(distinct case when build_a_bet = 't' and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then bets.id end) cash_bets_sgp,
      count(distinct case when build_a_bet != 't' and bet_type <> 'SINGLE' and 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE
          then bets.id end) cash_bets_parlays,
      count(distinct case when build_a_bet = 't'  then bets.id end) bets_sgp,
      count(distinct case when build_a_bet != 't' and bet_type <> 'SINGLE' then bets.id end) bets_parlays
  
  FROM
      FBG_SOURCE.OSB_SOURCE.bet_parts 
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.bets
      ON (bet_parts.bet_id = bets.id)
  LEFT OUTER JOIN
      fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa
      ON bets.id = sfsa.bet_id
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.accounts
      ON (bets.acco_id = accounts.id)
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.instruments
      ON (bet_parts.instrument_id = instruments.id)
  LEFT OUTER JOIN
      marketdefinitions md
      ON bet_parts.mrkt_type = md.market_type
  LEFT JOIN
      boost_percentage
      ON bets.bonus_campaign_id = boost_percentage.id
  LEFT JOIN
      event_info
      ON bet_parts.instrument_id = event_info.sel_id
  
  WHERE
      bets.status = 'ACCEPTED'
      and accounts.test = 0 
      AND bets.pointsbet_bet_id is NULL
      and teaser_price is null
      AND CASE 
              WHEN bets.fancash_stake_amount > 0
              AND bets.FREE_BET = FALSE
              AND sfsa.bet_id IS NULL THEN 0
              ELSE 1 
          END = 1
  
  GROUP BY ALL
  
  ),
  
  
  
  distinct_selections_1 AS (
  
      SELECT DISTINCT
          1 joinflag,
          instrument_id,
          max(event_name) event_name,
          max(event_time_et) event_time_et,
          max(winnercat) winnercat,
          max(market_boost_flag) market_boost_flag,
          max(selection_not_resulted) selection_not_resulted,
          max(market_id) market_id,
          max(node_id) node_id,
          max(COMP) COMP,
          max(SPORT) SPORT,
          max(selection) selection,
          max(mrkt_type) mrkt_type,
          max(market) market
  
      
  
      FROM
          singles_book_stage_stage
  
      GROUP BY
          ALL
  
  )
  
  --SELECT * from distinct_selections_1 where market_id = 94238468;
  
  ,
  
  distinct_channel_1 AS (
  
      SELECT DISTINCT
          1 join_flag,
          channel,
          jurisdictions_id,
          retail_venue_id
  
      
  
      FROM
          singles_book_stage_stage
  
  
  ),
  
  distinct_sel_and_channel_1 AS (
  
      SELECT
          joinflag,
          instrument_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          event_name,
          event_time_et,
          winnercat,
          market_boost_flag,
          selection_not_resulted,
          market_id,
          node_id,
          COMP,
          SPORT,
          selection,
          mrkt_type,
          market
  
      FROM
          distinct_selections_1 ds1 inner join distinct_channel_1 dc1 on ds1.joinflag = dc1.join_flag
      
  ),
      
  singles_book_stage1 AS (
  
      SELECT
          dsc1.joinflag,
          dsc1.instrument_id,
          dsc1.channel,
          dsc1.jurisdictions_id,
          dsc1.retail_venue_id,
          dsc1.event_name,
          dsc1.event_time_et,
          dsc1.winnercat,
          dsc1.market_boost_flag,
          dsc1.selection_not_resulted,
          dsc1.market_id,
          dsc1.node_id,
          dsc1.COMP,
          dsc1.SPORT,
          dsc1.selection,
          dsc1.mrkt_type,
          dsc1.market,
  
          //ADD in measures, wrapping COALESCE around
  
          COALESCE(single_bets,0) single_bets,
          COALESCE(single_cash_bets,0) single_cash_bets,
          COALESCE(singles_handle,0) singles_handle,
          COALESCE(singles_cash_handle,0) singles_cash_handle,
          COALESCE(singles_potential_payout,0) singles_potential_payout,
          COALESCE(singles_potential_payout_cash,0) singles_potential_payout_cash,
          
          
          COALESCE(total_handle_excl_sgp,0) total_handle_excl_sgp,
          COALESCE(total_handle_bet_excl_sgp,0) total_handle_bet_excl_sgp,
          COALESCE(total_cash_handle_excl_sgp,0) total_cash_handle_excl_sgp,
          COALESCE(total_cash_handle_bet_excl_sgp,0) total_cash_handle_bet_excl_sgp,
          
          COALESCE(total_handle_sgp,0) total_handle_sgp,
          COALESCE(total_handle_bet_sgp,0) total_handle_bet_sgp,
          COALESCE(total_cash_handle_sgp,0) total_cash_handle_sgp,
          COALESCE(total_cash_handle_bet_sgp,0) total_cash_handle_bet_sgp,
          
          COALESCE(parlay_handle,0) parlay_handle,
          COALESCE(parlay_handle_bet,0) parlay_handle_bet,
          COALESCE(parlay_cash_handle,0) parlay_cash_handle,
          COALESCE(parlay_cash_handle_bet,0) parlay_cash_handle_bet,
          
          
          
          COALESCE(cash_bets_sgp,0) cash_bets_sgp,
          COALESCE(cash_bets_parlays,0) cash_bets_parlays,
          COALESCE(bets_sgp,0) bets_sgp,
          COALESCE(bets_parlays,0) bets_parlays
      
  
      FROM
          distinct_sel_and_channel_1 dsc1 left outer join singles_book_stage_stage sbss on dsc1.instrument_id = sbss.instrument_id AND dsc1.channel = sbss.channel AND dsc1.jurisdictions_id = sbss.jurisdictions_id AND dsc1.retail_venue_id = sbss.retail_venue_id
  
  
  
  ),
  
  
  singles_book_stage AS (
  
      select
          
          *,
          max(event_time_et) over (partition by node_id) event_timee
          
      FROM
          
          singles_book_stage1
  
  
  
  ),
  
  
  singles_book AS (
  
      select
          
          
          case
              when 1=1 then 1 else 0
          end joinflag,
          concat(event_name,' - ',date(event_timee)) event,
          concat(comp,' - ',sport,' - ',event,' - ',event_timee,' - ',market,' - ',selection) sel,
          instrument_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          market_boost_flag,
          selection_not_resulted,
          market_id,
          node_id,
          COMP,
          SPORT,
          event_timee as Event_time,
          selection,
          mrkt_type,
          market,
          single_bets,
          singles_handle,
          singles_cash_handle,
          singles_potential_payout,
          singles_potential_payout_cash,
          
          total_handle_excl_sgp,
          total_handle_bet_excl_sgp,
          total_cash_handle_excl_sgp,
          total_cash_handle_bet_excl_sgp,
          
          total_handle_sgp,
          total_handle_bet_sgp,
          total_cash_handle_sgp,
          total_cash_handle_bet_sgp,
          
          parlay_handle,
          parlay_handle_bet,
          parlay_cash_handle,
          parlay_cash_handle_bet,
          
          
          
          cash_bets_sgp,
          cash_bets_parlays,
          bets_sgp,
          bets_parlays,
          singles_cash_handle - singles_potential_payout singles_liability_stage_mult,
          singles_cash_handle - singles_potential_payout_cash singles_liability_cash_stage_mult,
          sum(singles_cash_handle) over (partition by market_id, channel, jurisdictions_id, retail_venue_id) - singles_potential_payout   singles_liability_stage_one,
          sum(singles_cash_handle) over (partition by market_id, channel, jurisdictions_id, retail_venue_id) - singles_potential_payout_cash  singles_liability_cash_stage_one,
          sum(singles_cash_handle) over (partition by market_id, channel, jurisdictions_id, retail_venue_id) mark_id_total_bet_cash_handle_single,
          single_cash_bets+cash_bets_parlays open_cash_bets,
          winnercat
          
      from
          
          singles_book_stage
  
  ),
  
  
  bet_counts AS (
  
   SELECT
      CASE WHEN 1=1 THEN 1 ELSE 0 END AS joinflag,
      bets.channel,
      bets.jurisdictions_id,
      COALESCE(accounts.retail_venue_id,0) AS retail_venue_id,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE THEN bet_parts.bet_id END) AS sgp_bets,
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE AND 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
          THEN bet_parts.bet_id END) AS sgp_cash_bets,
      COUNT(DISTINCT CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' THEN bet_parts.bet_id END) AS parlay_bets,
      COUNT(DISTINCT CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' AND 
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
          THEN bet_parts.bet_id END) AS parlay_cash_bets,
  
      SUM(CASE WHEN build_a_bet = TRUE 
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                     THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines 
          ELSE 0 END) AS o_sgp_handle,
      SUM(CASE WHEN build_a_bet = TRUE AND 
              CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                     THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines 
          ELSE 0 END) AS o_sgp_cash_handle,
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' 
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                     THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines 
          ELSE 0 END) AS o_parlay_handle,
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' AND 
              CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END = FALSE 
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                     THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines 
          ELSE 0 END) AS o_parlay_cash_handle
  
  FROM
      FBG_SOURCE.OSB_SOURCE.bet_parts 
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.bets
      ON (bet_parts.bet_id = bets.id)
  LEFT OUTER JOIN
      fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa
      ON bets.id = sfsa.bet_id
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.accounts
      ON (bets.acco_id = accounts.id)
  LEFT OUTER JOIN 
      fbg_source.osb_source.instruments 
      ON bet_parts.instrument_id = instruments.id
  
  WHERE
      bets.status = 'ACCEPTED'
      AND accounts.test = 0
      AND bets.pointsbet_bet_id IS NULL
      AND teaser_price IS NULL
      AND (
          CASE
              WHEN instruments.result IS NULL THEN 1 
              WHEN instruments.result IN ('NOT_SET') THEN 1 ELSE 0 
          END = 1
      )
      AND CASE 
              WHEN bets.fancash_stake_amount > 0
              AND bets.FREE_BET = FALSE
              AND sfsa.bet_id IS NULL THEN 0
              ELSE 1 
          END = 1
  
  GROUP BY ALL
  
  
  
  )
  
  --select * from singles_book;
  
  ,
  
  event_bet_counts AS(
  
  
    SELECT
      node_id,
      bets.channel,
      bets.jurisdictions_id,
      COALESCE(accounts.retail_venue_id,0) AS retail_venue_id,
  
      SUM(
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                THEN COALESCE(sfsa.bonus_bet_amount, 0) 
                ELSE bets.total_stake END) / num_lines
      ) AS event_handle,
  
      SUM(
          CASE WHEN build_a_bet = TRUE 
               THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                          THEN COALESCE(sfsa.bonus_bet_amount, 0) 
                          ELSE bets.total_stake END) / num_lines 
               ELSE 0 END
      ) AS sgp_handle_event,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE THEN bet_parts.bet_id END) AS sgp_bets_event,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE 
                          AND CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE 
                                   THEN TRUE ELSE bets.FREE_BET END = FALSE 
                          THEN bet_parts.bet_id END) AS sgp_cash_bets_event
  
  FROM
      FBG_SOURCE.OSB_SOURCE.bet_parts 
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.bets
      ON (bet_parts.bet_id = bets.id)
  LEFT OUTER JOIN
      fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa
      ON bets.id = sfsa.bet_id
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.accounts
      ON (bets.acco_id = accounts.id)
  
  WHERE
      bets.status = 'ACCEPTED'
      AND accounts.test = 0
      AND bets.pointsbet_bet_id IS NULL
      AND teaser_price IS NULL
      AND CASE 
              WHEN bets.fancash_stake_amount > 0
              AND bets.FREE_BET = FALSE
              AND sfsa.bet_id IS NULL THEN 0
              ELSE 1 
          END = 1
  
  GROUP BY ALL
  
  ),
  
  event_bet_counts_agg AS(
      select
          
          node_id as nodeid_,
          sum(event_handle) o_event_handle
          
      from
          
          
          event_bet_counts
  
      GROUP BY
          ALL
  
  ),
  
  event_rank AS (
  
      SELECT
          *,
          rank() over (partition by 1 order by o_event_handle desc, nodeid_ desc) eventrank
  
      FROM
          event_bet_counts_agg
  
  ),
  
  
  fieldbook_data AS (
  
      SELECT
          
          singles_book.joinflag,
          singles_book.winnercat,
          singles_book.sel,
          singles_book.instrument_id,
          singles_book.channel,
          singles_book.jurisdictions_id,
          singles_book.retail_venue_id,
          singles_book.market_boost_flag,
          singles_book.selection_not_resulted,
          singles_book.market_id,
          singles_book.node_id,
          event_rank.eventrank,
          singles_book.COMP,
          singles_book.SPORT,
          singles_book.Event,
          singles_book.Event_time,
          replace(singles_book.selection,'49ers','FortyNiners') selection,
          singles_book.mrkt_type,
          case
              when singles_book.mrkt_type IN (
                  'BASKETBALL:FTOT:ML',
                  'BASKETBALL:FTOT:SPRD',
                  'AMERICAN_FOOTBALL:FTOT:SPRD',
                  'BASKETBALL:FTOT:OU',
                  'BASEBALL:FTOT:ML',
                  'AMERICAN_FOOTBALL:FTOT:ML',
                  'BASEBALL:FTOT:SPRD',
                  'BASEBALL:FTOT:OU',
                  'AMERICAN_FOOTBALL:FTOT:OU',
                  'ICE_HOCKEY:FTOT:ML',
                  'ICE_HOCKEY:FTOT:OU',
                  'ICE_HOCKEY:FTOT:SPRD'
              ) then 1 else 0
          end six_box_flag,
          singles_book.market,
          singles_book.single_bets,
          singles_book.singles_handle,
          singles_book.singles_cash_handle,
          singles_book.singles_potential_payout,
          singles_book.singles_potential_payout_cash,
          
          
          singles_book.total_handle_excl_sgp,
          singles_book.total_handle_bet_excl_sgp,
          singles_book.total_cash_handle_excl_sgp,
          singles_book.total_cash_handle_bet_excl_sgp,
          
          singles_book.total_handle_sgp,
          singles_book.total_handle_bet_sgp,
          singles_book.total_cash_handle_sgp,
          singles_book.total_cash_handle_bet_sgp,
          
          singles_book.parlay_handle,
          singles_book.parlay_handle_bet,
          singles_book.parlay_cash_handle,
          singles_book.parlay_cash_handle_bet,
          
          
          
          singles_book.cash_bets_sgp,
          singles_book.cash_bets_parlays,
          singles_book.bets_sgp,
          singles_book.bets_parlays,
          mark_id_total_bet_cash_handle_single,
          
          case
              when lower(singles_book.winnercat) = 'one' then singles_liability_stage_one else singles_liability_stage_mult
          end singles_liability,
          case
              when lower(singles_book.winnercat) = 'one' then singles_liability_cash_stage_one else singles_liability_cash_stage_mult
          end singles_liability_cash,
          
          
          
          
          COALESCE(total_bet_parlay_cash_handle, 0) AS total_bet_parlay_cash_handle,
          COALESCE(total_bet_parlay_handle, 0) AS total_bet_parlay_handle,
          COALESCE(total_bet_parlay_cash_handle_proportional, 0) AS total_bet_parlay_cash_handle_proportional,
          COALESCE(total_bet_parlay_handle_proportional, 0) AS total_bet_parlay_handle_proportional,
          COALESCE(running_up_dollars, 0) AS parlay_running_up_dollars,
          COALESCE(running_up_dollars_next_to_run, 0) AS parlay_running_up_dollars_next_to_run,
          COALESCE(running_up_dollars_if_selection_wins, 0) AS parlay_running_up_dollars_if_selection_wins,
          COALESCE(running_up_dollars_last_to_run, 0) AS parlay_running_up_dollars_last_to_run,
          COALESCE(parlay_payout_if_selection_wins, 0) AS parlay_payout_if_selection_wins,
          COALESCE(CASE WHEN lasttorunsel = 1 and multiples_run_ups.parlay_last_to_run_liability = 0 then market_channel_handle else multiples_run_ups.parlay_last_to_run_liability end , CASE WHEN lasttorunsel = 1 then market_channel_handle else 0 end) AS parlay_last_to_run_liability,
          --COALESCE(CASE WHEN lasttorunsel = 1 and multiples_run_ups.parlay_last_to_run_liability = 0 then market_channel_handle else multiples_run_ups.parlay_last_to_run_liability end , CASE WHEN lasttorunsel = 1 then market_channel_handle else 0 end) AS pl2rl,
          --COALESCE(case
          --    when lower(singles_book.winnercat) = 'one' then singles_liability_stage_one else singles_liability_stage_mult
         -- end,0) sl2rl,
          COALESCE(case
              when lower(singles_book.winnercat) = 'one' then singles_liability_stage_one else singles_liability_stage_mult
          end,0) + COALESCE(CASE WHEN lasttorunsel = 1 and multiples_run_ups.parlay_last_to_run_liability = 0 then market_channel_handle else multiples_run_ups.parlay_last_to_run_liability end , CASE WHEN lasttorunsel = 1 then market_channel_handle else 0 end,0) AS total_last_to_run_liability,
          --sl2rl+pl2rl total_last_to_run_liability_2,
          COALESCE(total_bet_parlay_handle_proportional, 0) + singles_handle AS avc,
          COALESCE(avc - total_handle_excl_sgp, 0) AS AVC_minusTotalHandle,
          COALESCE(original_bet_stake_next_to_run,0) original_bet_stake_next_to_run,
          COALESCE(original_bet_stake_last_to_run,0) original_bet_stake_last_to_run,
  
          --multiples_run_ups.parlay_last_to_run_liability,
          --lasttorunsel,
  
          
          bet_counts.sgp_bets,
          bet_counts.sgp_cash_bets,
          bet_counts.parlay_bets,
          bet_counts.parlay_cash_bets,
          
  
  
          sgp_cash_bets_event,
          sgp_bets_event,
          
  
          o_parlay_handle,
          o_parlay_cash_handle,
          o_sgp_handle,
          o_sgp_cash_handle,
          sgp_handle_event,
  
          COALESCE(original_bet_stake_last_to_run,0)+COALESCE(singles_handle,0) last_to_run_handle_running_through_selection,
          COALESCE(original_bet_stake_next_to_run,0) next_to_run_handle_running_through_selection,
          
          singles_book.open_cash_bets,
          
          
          COALESCE(parlay_cash_payout_if_selection_wins,0) AS parlay_cash_payout_if_selection_wins,
          --COALESCE(parlay_cash_last_to_run_liability,0) AS parlay_cash_last_to_run_liability,
          COALESCE(CASE WHEN lasttorunsel = 1 and multiples_run_ups.parlay_cash_last_to_run_liability = 0 then market_channel_handle else multiples_run_ups.parlay_cash_last_to_run_liability end , CASE WHEN lasttorunsel = 1 then market_channel_handle else 0 end) AS parlay_cash_last_to_run_liability,
          
          
          COALESCE(parlay_bonus_payout_if_selection_wins,0) AS parlay_bonus_payout_if_selection_wins, // take these out //
          --COALESCE(parlay_bonus_last_to_run_liability,0) AS parlay_bonus_last_to_run_liability
          --COALESCE(CASE WHEN lasttorunsel = 1 and multiples_run_ups.parlay_bonus_last_to_run_liability = 0 then market_channel_handle else multiples_run_ups.parlay_bonus_last_to_run_liability end , CASE WHEN lasttorunsel = 1 then market_channel_handle else 0 end) AS parlay_bonus_last_to_run_liability,
  
          COALESCE(parlay_last_to_run_liability,0)-COALESCE(parlay_cash_last_to_run_liability,0) AS parlay_bonus_last_to_run_liability // take these out //
      
      
      FROM
          singles_book
      LEFT OUTER JOIN
          multiples_run_ups
          ON singles_book.instrument_id = multiples_run_ups.instrument_id AND singles_book.channel = multiples_run_ups.channel AND singles_book.jurisdictions_id = multiples_run_ups.jurisdictions_id AND singles_book.retail_venue_id = multiples_run_ups.retail_venue_id
      left outer join
          bet_counts
          on singles_book.joinflag = bet_counts.joinflag AND singles_book.channel = bet_counts.channel AND singles_book.jurisdictions_id = bet_counts.jurisdictions_id AND singles_book.retail_venue_id = bet_counts.retail_venue_id
      left outer join
          event_bet_counts
          on singles_book.node_id = event_bet_counts.node_id AND singles_book.channel = event_bet_counts.channel AND singles_book.jurisdictions_id = event_bet_counts.jurisdictions_id AND singles_book.retail_venue_id = event_bet_counts.retail_venue_id
      left outer join
          event_rank
          on singles_book.node_id = event_rank.nodeid_
      left outer join
          multiple_market_handle
          on singles_book.market_id = multiple_market_handle.marketid_ AND singles_book.channel = multiple_market_handle.channel AND singles_book.jurisdictions_id = multiple_market_handle.jurisdictions_id AND singles_book.retail_venue_id = multiple_market_handle.retail_venue_id
      left outer join
          multiple_last_to_run
          on singles_book.instrument_id = multiple_last_to_run.instrument_id
      
      where
          selection_not_resulted = 1
  )
  
  --SELECT * from fieldbook_data  WHERE instrument_id = 479895933;
  
  
  ,
  
  
  market_handle
  
  as
  
  (
  
      select
          
          
          node_id event_id,
          market_id,
          max(mrkt_type) mrkt_type,
          sum(total_handle_excl_sgp+total_handle_sgp) market_handle
          
      from
          
          fieldbook_data
          
      where
          
          six_box_flag = 1
          
      GROUP BY
          
          ALL
  
  ),
  
  market_rank_stage AS (
  
      select
          
          *,
          rank() over (partition by event_id, mrkt_type order by market_handle desc, market_id desc) rankk
          
      from
          
          market_handle
  
  ),
  
  market_rank as (
  
      select
          
          *
          
      from
          
          market_rank_stage
          
          
      where
          
          rankk = 1
  
  ),
  
  fieldbook_data_2 AS (
  
      select
          
          fieldbook_data.*,
          case when six_box_flag = 1 and fieldbook_data.mrkt_type LIKE '%ML%' then 'Moneyline'
               when six_box_flag = 1 and fieldbook_data.mrkt_type LIKE '%SPR%' then 'Spread'
               when six_box_flag = 1 and fieldbook_data.mrkt_type LIKE '%OU%' then 'Points'
               end six_box_market,
          rankk
          
      from 
          
          fieldbook_data
      left outer join
          market_rank 
          on fieldbook_data.market_id = market_rank.market_id
  
  
  
  ),
  
  
  
  spread_number
  
  as
  
  (
      select
          
          
          instrument_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          total_last_to_run_liability,
          market_id,
          node_id,
          mrkt_type mrkttype,
          market,
          selection,
          case
              when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' then
                  case
                      when lower(selection) like '% +%' then '+' 
                      when lower(selection) like '% -%' then '-' else '+'
                  end
          end plus_or_minus,
          case
              when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' then
                  case
                      when selection like '% +%' then position(' +',lower(selection))
                      when selection like '% -%' then position(' -',lower(selection)) else REGEXP_INSTR(selection,'([0-9]+)')-1
                  end
          end pos,
          case
              when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:ML' then selection
              when pos is null then selection when pos > 0 then left(selection,pos) 
          end moneyline_selection,
          length(moneyline_selection) ml_length,
          case
              when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' then replace(replace(replace(substr(selection,ml_length+1,100),'+',''),'-',''),' ','')
          end spread_stage,
          REGEXP_INSTR(spread_stage,'([0-9]+)') num_pos,
          replace(substr(spread_stage,num_pos,100),' ','') spread
          
      from
          
          fieldbook_data_2
          
      where
          
          mrkt_type IN (
          'AMERICAN_FOOTBALL:FTOT:SPRD',
          'AMERICAN_FOOTBALL:FTOT:ML'
      )
  ),
  
  
  spread_full_join AS (
  
  
      select
          
          sn1.instrument_id,
          sn1.channel,
          sn1.jurisdictions_id,
          sn1.retail_venue_id,
          sn1.market_id,
          sn1.node_id,
          sn1.mrkttype,
          sn1.market,
          sn1.selection,
          sn1.plus_or_minus,
          sn1.moneyline_selection,
          sn1.spread,
          sn1.total_last_to_run_liability,
          
          sn2.instrument_id as instrument_id2,
          sn2.channel as channel2,
          sn2.jurisdictions_id as jurisdictions_id2,
          sn2.retail_venue_id as retail_venue_id2,
          sn2.market_id as market_id2,
          sn2.node_id as node_id2,
          sn2.mrkttype as mrkttype2,
          sn2.market as market2,
          sn2.selection as selection2,
          sn2.plus_or_minus as plus_or_minus2,
          sn2.moneyline_selection as moneyline_selection2,
          sn2.spread as spread2,
          sn2.total_last_to_run_liability as total_last_to_run_liability2,
          case
              when replace(sn1.moneyline_selection,' ','') = replace(sn2.moneyline_selection,' ','') then 1 else 0
              end selection_check,
          case
              when sn1.instrument_id <> sn2.instrument_id and  sn1.mrkttype = 'AMERICAN_FOOTBALL:FTOT:ML' and sn2.mrkttype <> 'AMERICAN_FOOTBALL:FTOT:ML' and replace(sn1.moneyline_selection,' ','') = replace(sn2.moneyline_selection,' ','') then sn1.total_last_to_run_liability
          end win_ml_liability_on_spread,
          case
              when sn1.instrument_id <> sn2.instrument_id and  sn1.mrkttype = 'AMERICAN_FOOTBALL:FTOT:ML' and sn2.mrkttype <> 'AMERICAN_FOOTBALL:FTOT:ML' and replace(sn1.moneyline_selection,' ','') <> replace(sn2.moneyline_selection,' ','') then sn1.total_last_to_run_liability
          end lose_ml_liability_on_spread,
          case 
              when sn1.market_id = sn2.market_id then 0 when  sn1.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn2.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn1.plus_or_minus = '+' and sn2.plus_or_minus = '+' and cast(sn2.spread as double) > cast(sn1.spread as double) and replace(sn1.moneyline_selection,' ','') = replace(sn2.moneyline_selection,' ','') then sn2.total_last_to_run_liability 
              when sn1.market_id = sn2.market_id then 0 when  sn1.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn2.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn1.plus_or_minus = '-' and sn2.plus_or_minus = '+' and replace(sn1.moneyline_selection,' ','') = replace(sn2.moneyline_selection,' ','') then sn2.total_last_to_run_liability
              when sn1.market_id = sn2.market_id then 0 when  sn1.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn2.mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD' and sn1.plus_or_minus = '-' and sn2.plus_or_minus = '-' and cast(sn2.spread as double) < cast(sn1.spread as double) and replace(sn1.moneyline_selection,' ','') = replace(sn2.moneyline_selection,' ','') then sn2.total_last_to_run_liability
              else 0
          end other_spread_libs
          
          
          
          
      from
          
          spread_number sn1
      inner join
          spread_number sn2
          on sn1.node_id = sn2.node_id
          AND
          sn1.channel = sn2.channel
          AND
          sn1.jurisdictions_id = sn2.jurisdictions_id
          AND
          sn1.retail_venue_id = sn2.retail_venue_id
  
  
  ),
  
  grouped_by_stage AS (
  
  
      select
          
          node_id,
          selection2,
          channel,
          jurisdictions_id,
          retail_venue_id,
          instrument_id2,
          moneyline_selection2,
          max(win_ml_liability_on_spread) win_ml_liability_on_spread,
          max(lose_ml_liability_on_spread) lose_ml_liability_on_spread
          
          
      from 
          
          spread_full_join
          
      where
          
          instrument_id <> instrument_id2
          and
          mrkttype = 'AMERICAN_FOOTBALL:FTOT:ML' and mrkttype2 <> 'AMERICAN_FOOTBALL:FTOT:ML'
          
          
      GROUP BY 
          
          ALL
  
  ),
  
  grouped_by AS (
  
  
      select
          
          node_id nodeid, 
          instrument_id2 selid,
          channel AS chan,
          jurisdictions_id AS jur_id,
          retail_venue_id AS ret_id,
          coalesce(win_ml_liability_on_spread,0) win_ml_liability_on_spread,
          coalesce(lose_ml_liability_on_spread,0) lose_ml_liability_on_spread
          
          
      from 
          
          grouped_by_stage
  
  ),
  
  
  spread_full_join_2
  
  AS (
  
  
      select
          
          instrument_id,
          channel,
          jurisdictions_id,
          retail_venue_id,
          market_id,
          node_id,
          mrkttype,
          market,
          selection,
          plus_or_minus,
          moneyline_selection,
          spread,
          total_last_to_run_liability selection_total_last_to_run_liability,
          sum(other_spread_libs) other_spread_libs,
          max(grouped_by.win_ml_liability_on_spread) total_last_to_run_liability_ml_win,
          max(grouped_by.lose_ml_liability_on_spread) total_last_to_run_liability_ml_lose
          
      FROM
          spread_full_join
      left outer join
          grouped_by
          on spread_full_join.instrument_id = grouped_by.selid
          AND spread_full_join.channel = grouped_by.chan
          AND spread_full_join.jurisdictions_id = grouped_by.jur_id
          AND spread_full_join.retail_venue_id = grouped_by.ret_id
          
          
          
      GROUP BY
          ALL
  ),
  
  spread_full_join_3 AS (
  
  
      select
          
          instrument_id selectionid,
          channel AS chan,
          jurisdictions_id AS jur_id,
          retail_venue_id AS ret_id,
          selection_total_last_to_run_liability,
          other_spread_libs,
          selection_total_last_to_run_liability+other_spread_libs+total_last_to_run_liability_ml_win sprd_and_win,
          case
              when plus_or_minus = '-' then NULL else selection_total_last_to_run_liability+other_spread_libs+total_last_to_run_liability_ml_lose
          end sprd_and_lose
          
      FROM
          
          spread_full_join_2
          
      where
          
          mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD'
  
  
  )
  
  
  
  
  
  
      SELECT
          
          fieldbook_data_2.*,
          CASE
              WHEN channel = 'INTERNET' then channel else COALESCE(retail_venues.name,'OTHER')
          END retail_venue_name,
          JURISDICTION_NAME,
          selection_total_last_to_run_liability,
          other_spread_libs other_spread_last_to_run_liability,
          case
              when mrkt_type ='AMERICAN_FOOTBALL:FTOT:SPRD' then selection_total_last_to_run_liability + other_spread_libs else total_last_to_run_liability
          end total_last_to_run_liability2,
          sprd_and_win sprd_and_win_last_to_run_liability,
          sprd_and_lose sprd_and_lose_last_to_run_liability,
          timestamp.max_timestamp
          
      from 
          
          fieldbook_data_2
      left outer join
          spread_full_join_3
          on fieldbook_data_2.instrument_id = spread_full_join_3.selectionid
          AND fieldbook_data_2.channel = spread_full_join_3.chan
          AND fieldbook_data_2.jurisdictions_id = spread_full_join_3.jur_id
          AND fieldbook_data_2.retail_venue_id = spread_full_join_3.ret_id
      left outer join
          timestamp
          on fieldbook_data_2.joinflag = timestamp.joinflag
      left outer join
          fbg_source.osb_source.retail_venues
          ON fieldbook_data_2.retail_venue_id = retail_venues.id
      left outer join
          fbg_source.osb_source.jurisdictions
          ON fieldbook_data_2.jurisdictions_id =  jurisdictions.id
) "Custom SQL Query"
