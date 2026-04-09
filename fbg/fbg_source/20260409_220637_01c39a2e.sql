-- Query ID: 01c39a2e-0212-6dbe-24dd-0703193f6483
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:06:37.224000+00:00
-- Elapsed: 88876ms
-- Environment: FBG

SELECT "Custom SQL Query"."AWAY_DIFFERENCE" AS "AWAY_DIFFERENCE",
  "Custom SQL Query"."AWAY_SCORE" AS "AWAY_SCORE",
  "Custom SQL Query"."AWAY_TEAM" AS "AWAY_TEAM",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_ID" AS "EVENT_ID",
  "Custom SQL Query"."HOME_DIFFERENCE" AS "HOME_DIFFERENCE",
  "Custom SQL Query"."HOME_SCORE" AS "HOME_SCORE",
  "Custom SQL Query"."HOME_TEAM" AS "HOME_TEAM",
  "Custom SQL Query"."MATCH_SCORE" AS "MATCH_SCORE",
  "Custom SQL Query"."MATCH_WINNER" AS "MATCH_WINNER",
  "Custom SQL Query"."MAX_TIMESTAMP" AS "MAX_TIMESTAMP",
  "Custom SQL Query"."ML_LIBS" AS "ML_LIBS",
  "Custom SQL Query"."POINTS_LIABILITY" AS "POINTS_LIABILITY",
  "Custom SQL Query"."SIX_BOX_LIBS" AS "SIX_BOX_LIBS",
  "Custom SQL Query"."SPREAD_LIABILITY" AS "SPREAD_LIABILITY",
  "Custom SQL Query"."TOTAL_POINTS" AS "TOTAL_POINTS"
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
      
      
          FBG_ANALYTICS.TRADING.MARKET_DEFINITIONS
      
      
      GROUP BY
          ALL
  ),
  
  timestamp AS
  
  (
      SELECT
  
          1 joinflag,
          max(greatest(CONVERT_TIMEZONE('UTC','America/New_York', bets.settlement_time),CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time))) max_timestamp
  
      FROM
  
          FBG_SOURCE.OSB_SOURCE.BETS
  
      WHERE
  
          CONVERT_TIMEZONE('UTC','America/New_York', bets.placed_time) >= current_date - 4 
  
      GROUP BY
          ALL
  
  ),
  
  event_info_stage AS (
  
  
      select
      
          instrument_id AS sel_id,
          bets.id,
          MAX(num_lines) AS numlines_,
          MAX(CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) AS bet_stake,
          MAX(CONVERT_TIMEZONE('UTC','America/New_York', event_time)) event_time_et,
          MAX(event) event_name,
          max(comp) comp,
          max(market) market,
          max(sport) sport
  
      
      
      
      from
          FBG_SOURCE.OSB_SOURCE.BET_PARTS
      inner join
          FBG_SOURCE.OSB_SOURCE.BETS
          on (bet_parts.bet_id = bets.id)
      inner join
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS
          on (bets.acco_id = accounts.id)
      LEFT OUTER JOIN
          FBG_ANALYTICS_ENGINEERING.STAGING.STG_FANCASH_STAKE_AMOUNTS  AS sfsa
          ON bets.id = sfsa.bet_id
  
      WHERE
      
      
          bets.status = 'ACCEPTED'
          and
          accounts.test = 0 
          AND 
          bets.pointsbet_bet_id is NULL
          and
          teaser_price is null
          AND
          CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE AND sfsa.bet_id IS NULL THEN 0
              ELSE 1
          END = 1
      
      
      
      GROUP BY
          ALL
  
  ),
  
  event_info AS (
  
      SELECT
          sel_id,
          SUM(bet_stake) AS bethandle_,
          SUM(bet_stake / numlines_) proportional_handle_,
          MAX(event_time_et) AS event_time_et,
          MAX(event_name) event_name,
          max(comp) comp,
          max(market) market,
          max(sport) sport
      
      FROM
          event_info_stage 
  
      GROUP BY
          ALL
  
  ),
  
  boost_percentage AS (
  
      SELECT
          id, 
          (parse_json(data):Bonus:oddsBoost:boostPercentage)/100 boost_percentage  
      FROM 
          FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS as  t
      WHERE
          t.DATA ILIKE '%boostPercentage%'
  
  ),
  
  
  stack_stage AS (
  
  
      SELECT
      
          bet_id,
          node_id,
          instrument_id,
          count(distinct node_id) over (partition by bet_id) eventsinbet,
          count(distinct instrument_id) over (partition by node_id, bet_id) selsonevent
      
      
      FROM
          FBG_SOURCE.OSB_SOURCE.BET_PARTS 
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.BETS
          ON (bet_parts.bet_id = bets.id)
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS
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
          max(total_price) bet_price,
          max(build_a_bet) sgp_flag,
          max(case when stack_legs.instrument_id is not null then 1 else 0 end) stack_flag,
          max(boost_percentage) boost_percentage,
          
          max(
              CASE
                  WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
                  ELSE bets.FREE_BET
              END
          ) AS free_bet, //fortuna update
  
          max(
              CASE
                  WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN 1
                  ELSE 0
              END
          ) AS fortuna_flag, //fortuna update
  
          count(distinct bet_parts.instrument_id) legs,
          count(distinct stack_legs.instrument_id) stacklegs,
          Max(num_lines) num_lines,
          count(distinct case when result_type IN ('PUSH','VOID','WIN') then bet_parts.instrument_id end) resulted_legs, -- add in paramatized option
          count(distinct case when result_type IN ('PUSH','VOID','WIN') then stack_legs.instrument_id end) resulted_stack_legs,
          EXP(SUM(LN(case when result_type IN ('PUSH','VOID') then 1 else price end))) max_price, -- add in paramatized option
          EXP(SUM(LN(case when result_type IN ('WIN') then price else 1 end))) winners_price -- add in paramatized option
          
      FROM
          FBG_SOURCE.OSB_SOURCE.BET_PARTS 
      inner join
          FBG_SOURCE.OSB_SOURCE.BETS
          on (bet_parts.bet_id = bets.id)
      inner join
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS
          on (bets.acco_id = accounts.id)
      left join
          boost_percentage
          on bets.bonus_campaign_id = boost_percentage.id
      left join
          stack_legs
          on bet_parts.bet_id = stack_legs.bet_id and bet_parts.instrument_id = stack_legs.instrument_id
          
      WHERE
          
          
          bets.status = 'ACCEPTED'
          and
          teaser_price is null
          and
          bet_type != 'SINGLE'
          and
          accounts.test = 0
          
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
              when sgp_flag = TRUE and stack_flag = 1 and stacklegs - resulted_stack_legs = 1 and remaining_legs = 1 then 1 else 0
          end = 1
  ),
  
  singles_book_stage_stage AS (
  
  
  SELECT
      instrument_id,
      MAX(event_info.bethandle_) AS bethandle_,
      MAX(event_info.proportional_handle_) AS proportional_handle_,
      MAX(event_name) event_name,
      MAX(event_time_et) event_time_et,
      MAX(COALESCE(winner_category,'ONE')) winnercat,
      MAX(CASE
          WHEN event_info.comp ILIKE '%boost%' THEN 1
          WHEN event_info.Market ILIKE '%boost%' THEN 1
          WHEN Mrkt_Type ILIKE '%boost%' THEN 1
          ELSE 0 END) market_boost_flag,
      MAX(CASE
          WHEN instruments.result IS NULL THEN 1
          WHEN instruments.result IN ('NOT_SET') THEN 1
          ELSE 0 END) selection_not_resulted,
      MAX(market_id) market_id,
      MAX(node_id) node_id,
      MAX(event_info.COMP) COMP,
      MAX(event_info.SPORT) SPORT,
      MAX(selection) selection,
      MAX(MRkt_TYPE) mrkt_type,
      MAX(event_info.market) market,
  
      COUNT(DISTINCT CASE WHEN bet_type = 'SINGLE' THEN bet_parts.bet_id END) single_bets,
      COUNT(DISTINCT CASE WHEN bet_type = 'SINGLE' AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN bet_parts.bet_id END) single_cash_bets,
  
      SUM(CASE WHEN bet_type = 'SINGLE'
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) singles_handle,
  
      SUM(CASE WHEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE AND bet_type = 'SINGLE'
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) singles_cash_handle,
  
      SUM(CASE
              --WHEN bet_type = 'SINGLE' AND bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN (COALESCE(sfsa.bonus_bet_amount, 0) * (total_price-1))
              WHEN bet_type = 'SINGLE' AND FREE_BET = TRUE THEN (total_stake * (total_price-1))
              WHEN bet_type = 'SINGLE' THEN (total_stake * total_price)
              ELSE 0
          END
          ) singles_potential_payout,
  
      SUM(CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN 0
              WHEN free_bet = TRUE THEN 0
              WHEN bet_type = 'SINGLE' THEN (total_stake * total_price)
              ELSE 0
          END
          ) singles_potential_payout_cash,
  
  
  
      -- Similar replacements below for handle columns
      SUM(CASE WHEN build_a_bet = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS total_handle_excl_sgp,
  
      SUM(CASE WHEN build_a_bet = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS total_handle_bet_excl_sgp,
  
      SUM(CASE WHEN build_a_bet = FALSE AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS total_cash_handle_excl_sgp,
  
      SUM(CASE WHEN build_a_bet = FALSE AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS total_cash_handle_bet_excl_sgp,
  
      SUM(CASE WHEN build_a_bet = TRUE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS total_handle_sgp,
  
      SUM(CASE WHEN build_a_bet = TRUE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS total_handle_bet_sgp,
  
      SUM(CASE WHEN build_a_bet = TRUE AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS total_cash_handle_sgp,
  
      SUM(CASE WHEN build_a_bet = TRUE AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS total_cash_handle_bet_sgp,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE'
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS parlay_handle,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE'
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS parlay_handle_bet,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END) / num_lines
          ELSE 0 END) AS parlay_cash_handle,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <> 'SINGLE' AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE bets.total_stake END)
          ELSE 0 END) AS parlay_cash_handle_bet,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = 't' AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN bets.id END) cash_bets_sgp,
  
      COUNT(DISTINCT CASE WHEN build_a_bet != 't' AND bet_type <> 'SINGLE' AND
          (CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE ELSE bets.FREE_BET END) = FALSE
          THEN bets.id END) cash_bets_parlays,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = 't' THEN bets.id END) bets_sgp,
      COUNT(DISTINCT CASE WHEN build_a_bet != 't' AND bet_type <> 'SINGLE' THEN bets.id END) bets_parlays
  
  FROM FBG_SOURCE.OSB_SOURCE.BET_PARTS AS bet_parts
  
  INNER JOIN fbg_source.osb_source.bets AS bets
      ON (bet_parts.bet_id = bets.id)
  INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS AS accounts
      ON (bets.acco_id = accounts.id)
  INNER JOIN FBG_SOURCE.OSB_SOURCE.INSTRUMENTS AS instruments
      ON (bet_parts.instrument_id = instruments.id)
  LEFT OUTER JOIN marketdefinitions md
      ON bet_parts.mrkt_type = md.market_type
  LEFT JOIN boost_percentage
      ON bets.bonus_campaign_id = boost_percentage.id
  LEFT JOIN event_info
      ON bet_parts.instrument_id = event_info.sel_id
  
  -- **NEW JOIN per requirements**
  LEFT OUTER JOIN FBG_ANALYTICS_ENGINEERING.STAGING.STG_FANCASH_STAKE_AMOUNTS  AS sfsa
      ON bets.id = sfsa.bet_id
  
  WHERE
      bets.status = 'ACCEPTED'
      AND accounts.test = 0
      AND bets.pointsbet_bet_id IS NULL
      AND teaser_price IS NULL
      -- **NEW REQUIRED CONDITION**
      AND (
        CASE
          WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE AND sfsa.bet_id IS NULL THEN 0
          ELSE 1
        END = 1
      )
  
  GROUP BY ALL
  
  ),
  
  singles_book_stage AS (
  
      select
          
          *,
          max(event_time_et) over (partition by node_id) event_timee
          
      FROM
          
          singles_book_stage_stage
  
  
  
  ),
  
  
  singles_book AS (
  
      select
          
          
          case
              when 1=1 then 1 else 0
          end joinflag,
          event_name ||' - ' || date(event_timee) event,
          comp || ' - ' || sport || ' - ' || event || ' - ' || event_timee || ' - ' || market || ' - ' ||selection as sel,
          instrument_id,
          bethandle_,
          proportional_handle_,
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
          sum(singles_cash_handle) over (partition by market_id) - singles_potential_payout   singles_liability_stage_one,
          sum(singles_cash_handle) over (partition by market_id) - singles_potential_payout_cash  singles_liability_cash_stage_one,
          sum(singles_cash_handle) over (partition by market_id) mark_id_total_bet_cash_handle_single,
          single_cash_bets+cash_bets_parlays open_cash_bets,
          winnercat
          
      from
          
          singles_book_stage
  
  ),
  
  multiples_run_up_stage_stage_1 AS(
  
  
      select
      
          bet_parts.bet_id,
          stack_flag,
          COALESCE(fortuna_flag,0) AS fortuna_flag,
          bet_price,
          boost_percentage,
          winning_prices.free_bet, //dont need to update as updated in previous CTE which this references//
          instrument_id,
          market_id,
          selection,
          market,
          bet_parts.mrkt_type,
          CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE
              THEN COALESCE(sfsa.bonus_bet_amount, 0)
              ELSE stake
          END AS stake,
          price,
          potential_payout_price,
          legs,
          winning_prices.num_lines,
          resulted_legs,
          max_price,
          winners_price,
          remaining_legs,
          case when result_type IN ('NOT_SET') then 1 else 0 end not_resulted, 
          case when not_resulted = 1 and remaining_legs = 1 then 1 else 0 end last_to_run,
          case when not_resulted = 1 and remaining_legs > 1 then 1 else 0 end next_to_run,
          coalesce(winner_category,'ONE') winnercat,
          sum(
              CASE
                  WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE
                  THEN COALESCE(sfsa.bonus_bet_amount, 0)
                  ELSE stake
              END
          ) over (partition by market_id) parlay_market_handle_non_prop,
  
  
          sum(
              CASE
                  WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN 0
                  WHEN bets.free_bet = TRUE then 0 
                  ELSE stake
              END
          ) over (partition by market_id) parlay_market_handle_non_prop_cash
      
      from
      
          FBG_SOURCE.OSB_SOURCE.BET_PARTS
      inner join
          winning_prices
          on (bet_parts.bet_id = winning_prices.bet_id)
      inner join
          FBG_SOURCE.OSB_SOURCE.BETS
          on (bet_parts.bet_id = bets.id)
      left outer join
          marketdefinitions md
          on bet_parts.mrkt_type = md.market_type
      LEFT OUTER JOIN
          FBG_ANALYTICS_ENGINEERING.STAGING.STG_FANCASH_STAKE_AMOUNTS  AS sfsa
          ON bets.id = sfsa.bet_id
          
  
      WHERE
          STATUS = 'ACCEPTED'
          AND (
          CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE AND sfsa.bet_id IS NULL THEN 0
              ELSE 1
          END = 1
      )
  
  ),
  
  multiple_market_handle AS (
  
      SELECT
          market_id,
          MAX(parlay_market_handle_non_prop) AS parlay_market_handle_non_prop,
          MAX(parlay_market_handle_non_prop_cash) AS parlay_market_handle_non_prop_cash
      FROM
          multiples_run_up_stage_stage_1
      GROUP BY
          ALL
  ),
  
  parlay_selections AS (
  
  
      SELECT
          s.instrument_id AS sel_id_,
          MAX(s.market_id) AS market_id,
          MAX(s.selection) AS selection,
          MAX(s.market) AS market,
          MAX(s.mrkt_type) AS mrkt_type,
          MAX(s.winnercat) winner_cat,
          MAX(parlay_market_handle_non_prop) AS parlay_market_handle_non_prop,
          MAX(parlay_market_handle_non_prop_cash) AS parlay_market_handle_non_prop_cash,
  
      FROM
          singles_book AS s
      LEFT OUTER JOIN
          multiple_market_handle AS m
          ON s.market_id = m.market_id
      WHERE
          1=1
      GROUP BY
          ALL
  ),
  
  faux_parlay_bets AS (
      SELECT
          sel_id_||12345 AS bet_id,
          0 AS stack_flag,
          0 AS fortuna_flag,
          0 AS bet_price,
          NULL AS boost_percentage,
          FALSE AS free_bet, 
          sel_id_ AS instrument_id,
          market_id,
          selection,
          market,
          mrkt_type,
          0 AS stake,
          0 AS price,
          0 AS potential_payout_price,
          2 AS legs,
          2 AS num_lines,
          1 AS resulted_legs,
          0 AS max_price,
          0 AS winners_price,
          1 AS remaining_legs,
          1 AS not_resulted, 
          1 AS last_to_run,
          0 AS next_to_run,
          winner_cat,
          parlay_market_handle_non_prop,
          parlay_market_handle_non_prop_cash,
      FROM
          parlay_selections
  ),
  
  multiples_run_up_stage_stage AS (
  
      SELECT * FROM multiples_run_up_stage_stage_1
      UNION
      SELECT * FROM faux_parlay_bets
  ),
  
  sel_last_leg AS (
  
  
      SELECT
          instrument_id AS sel_id_,
          MAX(last_to_run) sel_last_leg
      FROM
          multiples_run_up_stage_stage
      WHERE
          free_bet = FALSE
      GROUP BY
          ALL
  ),
  
  multiples_run_ups_stage AS (
  
      select
      
          instrument_id,
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
          sum(case when not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,fortuna_flag)))+stake - case when free_bet = TRUE then stake else 0 end
                   when not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * COALESCE(potential_payout_price, bet_price)  - case when free_bet = TRUE then stake else 0 end
          else 0 end) parlay_payout_if_selection_wins,
  
          
        sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,fortuna_flag)))+stake
                   when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * COALESCE(potential_payout_price, bet_price) 
          else 0 end) parlay_cash_payout_if_selection_wins,
          
  
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) <> 'one' then stake else 0 end) 
          +
          max(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) = 'one' then parlay_market_handle_non_prop_cash else 0 end) 
          -
          sum(case when COALESCE(sel_last_leg,0) = 0 THEN 0 when free_bet = FALSE and not_resulted = 1 and next_to_run = 1  and lower(winnercat) = 'one' then stake else 0 end) // added this in to take out the handle that will not settle if this selection is settled immediately as a winner  [added in additional criteria around winnercat]
          - 
          sum(case when not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,fortuna_flag)))+stake - case when free_bet = TRUE then stake else 0 end
                   when not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * COALESCE(potential_payout_price, bet_price)  - case when free_bet = TRUE then stake else 0 end
          else 0 end)  parlay_last_to_run_liability,
          
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) <> 'one' then stake else 0 end) 
          +
          max(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1  and lower(winnercat) = 'one' then parlay_market_handle_non_prop_cash else 0 end) 
          -
          sum(case when COALESCE(sel_last_leg,0) = 0 THEN 0 when free_bet = FALSE and not_resulted = 1 and next_to_run = 1  and lower(winnercat) = 'one' then stake else 0 end) // added this in to take out the handle that will not settle if this selection is settled immediately as a winner  [added in additional criteria around winnercat] 
          - 
          sum(case when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then (((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,fortuna_flag)))+stake
                   when free_bet = FALSE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then stake * COALESCE(potential_payout_price, bet_price) 
          else 0 end) parlay_cash_last_to_run_liability,
          
          /*sum(case when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then ((((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake) - case when free_bet = TRUE then stake else 0 end // ADDED IN LAST BIT
                   when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then (stake * bet_price) - case when free_bet = TRUE then stake else 0 end // ADDED IN LAST BIT
          else 0 end) parlay_bonus_payout_if_selection_wins,
          sum(case when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 0 then ((((winners_price * stake * price)-stake)*(1+coalesce(boost_percentage,0)))+stake) - case when free_bet = TRUE then stake else 0 end //ADDED IN LAST BIT
                   when free_bet = TRUE and not_resulted = 1 and last_to_run = 1 and stack_flag = 1 then (stake * bet_price) - case when free_bet = TRUE then stake else 0 end // ADDED IN LAST BIT
          else 0 end*-1)  parlay_bonus_last_to_run_liability*/
      
      FROM
      
          multiples_run_up_stage_stage
      LEFT OUTER JOIN
          sel_last_leg
          ON multiples_run_up_stage_stage.instrument_id = sel_last_leg.sel_id_    
      GROUP BY
          ALL
  
  
  ),
  
  multiples_run_ups AS (
  
      select
      
          *
      
      from
      
      
          multiples_run_ups_stage
      
      where
      
          not_resulted = 1
      
      order by 
      
          parlay_payout_if_selection_wins desc
  
  ),
  
  bet_counts AS (
  
  SELECT
      CASE WHEN 1=1 THEN 1 ELSE 0 END joinflag,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE THEN bp.bet_id END) sgp_bets,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = TRUE
          AND (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN TRUE ELSE b.FREE_BET END) = FALSE
          THEN bp.bet_id END) sgp_cash_bets,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = FALSE AND bet_type <>'SINGLE' THEN bp.bet_id END) parlay_bets,
  
      COUNT(DISTINCT CASE WHEN build_a_bet = FALSE AND bet_type <>'SINGLE'
          AND (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN TRUE ELSE b.FREE_BET END) = FALSE
          THEN bp.bet_id END) parlay_cash_bets,
  
      SUM(CASE WHEN build_a_bet = TRUE
          THEN (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE b.total_stake END)/num_lines
          ELSE 0 END) o_sgp_handle,
  
      SUM(CASE WHEN build_a_bet = TRUE
          AND (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN TRUE ELSE b.FREE_BET END) = FALSE
          THEN (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE b.total_stake END)/num_lines
          ELSE 0 END) o_sgp_cash_handle,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <>'SINGLE'
          THEN (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE b.total_stake END)/num_lines
          ELSE 0 END) o_parlay_handle,
  
      SUM(CASE WHEN build_a_bet = FALSE AND bet_type <>'SINGLE'
          AND (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN TRUE ELSE b.FREE_BET END) = FALSE
          THEN (CASE WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE THEN COALESCE(sfsa.bonus_bet_amount, 0) ELSE b.total_stake END)/num_lines
          ELSE 0 END) o_parlay_cash_handle
  
  FROM
      FBG_SOURCE.OSB_SOURCE.BET_PARTS as bp
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.BETS as b
      ON (bp.bet_id = b.id)
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.ACCOUNTS as accounts
      ON (b.acco_id = accounts.id)
  LEFT OUTER JOIN
      FBG_SOURCE.OSB_SOURCE.INSTRUMENTS as instruments
      ON bp.instrument_id = instruments.id
  
  -- **Required JOIN for fancash logic**
  LEFT OUTER JOIN
      FBG_ANALYTICS_ENGINEERING.STAGING.STG_FANCASH_STAKE_AMOUNTS  AS sfsa
      ON b.id = sfsa.bet_id
  
  WHERE
      b.status = 'ACCEPTED'
      AND accounts.test = 0
      AND b.pointsbet_bet_id IS NULL
      AND teaser_price IS NULL
      AND (
          CASE WHEN instruments.result IS NULL THEN 1
               WHEN instruments.result IN ('NOT_SET') THEN 1 ELSE 0 END = 1
      )
      -- **NEW REQUIRED CONDITION**
      AND (
          CASE
              WHEN b.fancash_stake_amount > 0 AND b.FREE_BET = FALSE AND sfsa.bet_id IS NULL THEN 0
              ELSE 1
          END = 1
      )
  
  GROUP BY ALL
  
  
  
  ),
  
  event_bet_counts_stage_ AS(
  
  
  SELECT
      node_id,
      bet_parts.bet_id,
      MAX(CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE
               THEN COALESCE(sfsa.bonus_bet_amount, 0)
               ELSE bets.total_stake
          END) event_handle,
  
      MAX(CASE
              WHEN build_a_bet = TRUE
              THEN
                  CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE
                       THEN COALESCE(sfsa.bonus_bet_amount, 0)
                       ELSE bets.total_stake
                  END
              ELSE 0
          END) sgp_handle_event,
  
      MAX(CASE WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE
               THEN TRUE ELSE bets.FREE_BET END) free_bet,
  
      MAX(build_a_bet) build_a_bet
  
  FROM
      FBG_SOURCE.OSB_SOURCE.BET_PARTS AS bet_parts
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.BETS AS bets
      ON (bet_parts.bet_id = bets.id)
  INNER JOIN
      FBG_SOURCE.OSB_SOURCE.ACCOUNTS AS accounts
      ON (bets.acco_id = accounts.id)
  -- Required join for fancash
  LEFT OUTER JOIN
      FBG_ANALYTICS_ENGINEERING.STAGING.STG_FANCASH_STAKE_AMOUNTS  AS sfsa
      ON bets.id = sfsa.bet_id
  
  WHERE
      bets.status = 'ACCEPTED'
      AND accounts.test = 0
      AND bets.pointsbet_bet_id IS NULL
      AND teaser_price IS NULL
      AND (
          CASE
              WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE AND sfsa.bet_id IS NULL THEN 0
              ELSE 1
          END = 1
      )
  
  GROUP BY
      ALL
  
  ),
  
  event_bet_counts_stage AS (
      SELECT
          node_id,
          sum(event_handle) event_handle,
          sum(sgp_handle_event) sgp_handle_event,
          count(distinct case when build_a_bet = TRUE then bet_id end) sgp_bets_event,
          count(distinct case when build_a_bet = TRUE and free_bet = FALSE then bet_id end) sgp_cash_bets_event
      FROM
          event_bet_counts_stage_
      GROUP BY
          ALL
  ),
  event_bet_counts AS(
      select
          
          *,
          rank() over (partition by 1 order by event_handle desc, node_id desc) eventrank
          
      from
          
          
          event_bet_counts_stage
  
  ),
  
  
  
  fieldbook_data AS (
  
      SELECT
          
          singles_book.joinflag,
          singles_book.winnercat,
          singles_book.sel,
          singles_book.instrument_id,
          singles_book.bethandle_,
          singles_book.proportional_handle_,
          singles_book.market_boost_flag,
          singles_book.selection_not_resulted,
          singles_book.market_id,
          singles_book.node_id,
          eventrank,
          CASE
              WHEN lower(singles_book.COMP) LIKE '%nfl%' THEN 'NFL'
              ELSE lower(singles_book.COMP)
          END As COMP,
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
          --mark_id_total_bet_cash_handle_single,
          
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
          COALESCE(parlay_last_to_run_liability, 0) AS parlay_last_to_run_liability,
          COALESCE(singles_liability,0) + COALESCE(parlay_last_to_run_liability, 0) AS total_last_to_run_liability,
          COALESCE(total_bet_parlay_handle_proportional, 0) + singles_handle AS avc,
          COALESCE(avc - total_handle_excl_sgp, 0) AS AVC_minusTotalHandle,
          COALESCE(original_bet_stake_next_to_run,0) original_bet_stake_next_to_run,
          COALESCE(original_bet_stake_last_to_run,0) original_bet_stake_last_to_run,
          
          
          
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
          COALESCE(parlay_cash_last_to_run_liability,0) AS parlay_cash_last_to_run_liability,
          
          
          -1*(COALESCE(parlay_last_to_run_liability,0)-COALESCE(parlay_cash_last_to_run_liability,0)) AS parlay_bonus_payout_if_selection_wins, // take these out //
          COALESCE(parlay_last_to_run_liability,0)-COALESCE(parlay_cash_last_to_run_liability,0) AS parlay_bonus_last_to_run_liability // take these out //
      
      
      FROM
          singles_book
      LEFT OUTER JOIN
          multiples_run_ups
          ON singles_book.instrument_id = multiples_run_ups.instrument_id
      left outer join
          bet_counts
          on singles_book.joinflag = bet_counts.joinflag
      left outer join
          event_bet_counts
          on singles_book.node_id = event_bet_counts.node_id
      
      where
          selection_not_resulted = 1
  )
  
  --select * from fieldbook_data where instrument_id = 108374942;
  
  
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
          
          spread_number sn1 inner join spread_number sn2 on sn1.node_id = sn2.node_id
  
  
  ),
  
  grouped_by_stage AS (
  
  
      select
          
          node_id,
          selection2,
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
          coalesce(win_ml_liability_on_spread,0) win_ml_liability_on_spread,
          coalesce(lose_ml_liability_on_spread,0) lose_ml_liability_on_spread
          
          
      from 
          
          grouped_by_stage
  
  ),
  
  
  spread_full_join_2
  
  AS (
  
  
      select
          
          instrument_id,
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
          
          
          
      GROUP BY
          ALL
  ),
  
  spread_full_join_3 AS (
  
  
      select
          
          instrument_id selectionid,
          selection_total_last_to_run_liability,
          other_spread_libs,
          selection_total_last_to_run_liability+other_spread_libs+total_last_to_run_liability_ml_win sprd_and_win,
          case
              when plus_or_minus = '-' then NULL else selection_total_last_to_run_liability+other_spread_libs+total_last_to_run_liability_ml_lose
          end sprd_and_lose,
  
          plus_or_minus, // added in
          moneyline_selection, //added in
          spread, //added in
          
      FROM
          
          spread_full_join_2
          
      where
          
          mrkttype = 'AMERICAN_FOOTBALL:FTOT:SPRD'
  
  
  ),
  
  field_book AS (
  
  
  
      SELECT
          
          fieldbook_data_2.*,
          CASE
              WHEN DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', Event_time))
                      = DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', CURRENT_TIMESTAMP)) THEN 'Today'
              WHEN DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', Event_time))
                      < DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', CURRENT_TIMESTAMP)) THEN 'Before Today'
              WHEN DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', Event_time))
                      > DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', CURRENT_TIMESTAMP)) THEN 'After Today'
              ELSE 'Other'
          END AS today_flag,
          selection_total_last_to_run_liability,
          other_spread_libs other_spread_last_to_run_liability,
          case
              when mrkt_type ='AMERICAN_FOOTBALL:FTOT:SPRD' then selection_total_last_to_run_liability + other_spread_libs else total_last_to_run_liability
          end total_last_to_run_liability2,
          sprd_and_win sprd_and_win_last_to_run_liability,
          sprd_and_lose sprd_and_lose_last_to_run_liability,
  
          plus_or_minus, // added in
          moneyline_selection, //added in
          spread, //added in
          timestamp.max_timestamp,
          current_timestamp() AS dw_last_updated
          
      from 
          
          fieldbook_data_2
      left outer join
          spread_full_join_3
          on fieldbook_data_2.instrument_id = spread_full_join_3.selectionid
      left outer join
          timestamp
          on fieldbook_data_2.joinflag = timestamp.joinflag
  
  ),
  
  team_scores AS (
      select 
          distinct
          1 join_flag,
          week_number
      
      from
          fbg_analytics.product_and_customer.t_calendar 
  
  ),
  
  
  grid_stage AS
  
  (
  
      select
  
  
          wn1.week_number  home_score,
          wn2.week_number away_score,
          max_timestamp,
          instrument_id,
          market_id,
          node_id,
          sel,
          sport,
          event,
          event_time,
          selection,
          mrkt_type,
          market,
          plus_or_minus,
          moneyline_selection,
          spread,
          total_last_to_run_liability,
          case when mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:OU') then replace(replace(replace(lower(selection),'over ',''),'under ',''),' ','') end points_line,
          replace(replace(event,' vs ',' v '),' vs. ',' v ') event_2,
          REGEXP_INSTR(event_2,' v ') v_pos,
          trim(SUBSTRING(event_2,1,v_pos)) home_team,
          substr(event_2,v_pos+2,100) after_v,
          REGEXP_INSTR(after_v,' - 2') date_pos,
          trim(SUBSTRING(after_v,1,date_pos-1)) away_team,
          home_score + away_score total_points,
          case when home_score > away_score then home_team when away_score > home_score then away_team else 'Tie' end match_winner,
          home_score - away_score home_difference,
          away_score - home_score away_difference,
          trim(case when mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:SPRD') then moneyline_selection 
               when mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:ML') then selection end) team_bet_on
  
  
      from
  
  
          field_book
      inner join
          team_scores wn1
          on field_book.joinflag = wn1.join_flag
      inner join
          team_scores wn2
          on field_book.joinflag = wn2.join_flag 
  
      where 
          mrkt_type IN
              (
              
              'AMERICAN_FOOTBALL:FTOT:SPRD',
              'AMERICAN_FOOTBALL:FTOT:ML',
              'AMERICAN_FOOTBALL:FTOT:OU'
              )
  
  )
  
  
  select
  
      node_id event_id,
      max_timestamp,
      event,
      home_team,
      home_score,
      away_team,
      away_score,
      match_winner,
      home_difference,
      away_difference,
      total_points,
      home_team||' '||home_score||' - '||away_score||' '||away_team match_score,
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:ML' then case when match_winner = team_bet_on  then total_last_to_run_liability
                                                                      when match_winner =  team_bet_on  then total_last_to_run_liability
                                                                      else 0 end else 0 end) ML_libs,
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and home_team = team_bet_on and plus_or_minus = '+' and home_difference+spread > 0 then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and home_team = team_bet_on and plus_or_minus = '-' and home_difference > spread then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and away_team = team_bet_on and plus_or_minus = '+' and away_difference+spread > 0 then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and away_team = team_bet_on and plus_or_minus = '-' and away_difference > spread then total_last_to_run_liability
               else 0 end) spread_liability,
      
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:OU' and lower(selection) like '%under%' and total_points < points_line then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:OU' and lower(selection) like '%over%' and total_points > points_line then total_last_to_run_liability
      
               else 0 end) points_liability,
      
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:ML' then case when match_winner = team_bet_on  then total_last_to_run_liability
                                                                      when match_winner =  team_bet_on  then total_last_to_run_liability
                                                                      else 0 end else 0 end) +
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and home_team = team_bet_on and plus_or_minus = '+' and home_difference+spread > 0 then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and home_team = team_bet_on and plus_or_minus = '-' and home_difference > spread then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and away_team = team_bet_on and plus_or_minus = '+' and away_difference+spread > 0 then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' and away_team = team_bet_on and plus_or_minus = '-' and away_difference > spread then total_last_to_run_liability
               else 0 end)+
      
      sum(case when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:OU' and lower(selection) like '%under%' and total_points < points_line then total_last_to_run_liability
               when mrkt_type = 'AMERICAN_FOOTBALL:FTOT:OU' and lower(selection) like '%over%' and total_points > points_line then total_last_to_run_liability
      
               else 0 end)          six_box_libs
           
  
  FROM
  
      grid_stage
  
  
  where
  
  lower(event) like '%patriots%'
  and
  lower(event) like '%seahawks%'
  and
  node_id = 3668598
  and
  home_score <> away_score
  
  
  GROUP BY
  
  ALL
) "Custom SQL Query"
