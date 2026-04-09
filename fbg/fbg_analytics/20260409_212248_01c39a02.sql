-- Query ID: 01c39a02-0212-6dbe-24dd-0703193518c3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:22:48.948000+00:00
-- Elapsed: 51085ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AVG_STAKE_SIZE" AS "AVG_STAKE_SIZE",
  "Custom SQL Query"."BET_FUND_TYPE" AS "BET_FUND_TYPE",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."BET_TYPE" AS "BET_TYPE",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FAIRPLAY" AS "FAIRPLAY",
  "Custom SQL Query"."LEGS" AS "LEGS",
  "Custom SQL Query"."ODDS" AS "ODDS",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME" AS "PLACED_TIME",
  "Custom SQL Query"."POSSIBLE_WIN" AS "POSSIBLE_WIN",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SETTLED_TIME" AS "SETTLED_TIME",
  "Custom SQL Query"."SPORT" AS "SPORT",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  with avg_bets as(
  select
      a.acco_id,
      avg(a.total_stake) as avg_stake_size
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
  on a.acco_id = cm.acco_id
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
  ON a.id = sfsa.bet_id
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('ACCEPTED', 'SETTLED')
  and a.channel = 'INTERNET'
  and cm.vip_host is not null
  and cm.vip_host not in ('VIP Host Holdout', 'Amelco Integration')
  and a.free_bet = FALSE
  and a.fancash_stake_amount = 0
  
  group by all
  ),
  
  fairplay as(
  select
  distinct wager_id as bet_id
  from fbg_analytics_engineering.trading.trading_sportsbook_mart a
  where 1=1
  and a.leg_result_reason = 'FAIRNESS'
  and a.wager_result in ('WIN', 'PUSH')
  and a.wager_placed_time_alk >= '2025-08-23'
  )
  
  select  a.acco_id,
          ab.avg_stake_size,
          cm.vip_host,
          cm.f1_loyalty_tier,
          convert_timezone('UTC','America/New_York', a.placed_time) as placed_time,
          convert_timezone('UTC','America/New_York', a.settlement_time) as settled_time,
          a.id as bet_id,
          CASE WHEN a.fancash_stake_amount > 0 AND free_bet = FALSE THEN 'FC Bet'
               WHEN a.free_bet = TRUE THEN 'Bonus Bet'
               ELSE 'Cash Bet'
          END as bet_fund_type,
          CASE WHEN a.status = 'ACCEPTED' THEN 'Open'
               WHEN a.status = 'SETTLED' AND a.result = 4 THEN 'Cashout'
               WHEN a.status = 'SETTLED' AND a.payout = 0 THEN 'Loss'
               WHEN a.status = 'SETTLED' AND a.payout > 0 THEN 'Win'
          END as bet_status,
          CASE WHEN a.fancash_stake_amount > 0 THEN COALESCE(sfsa.bonus_bet_amount, 0)
               ELSE a.total_stake
          END AS stake,
          CASE WHEN a.Build_A_Bet = 't' then 'SGP' 
                WHEN a.Teaser_Price IS NOT NULL THEN 'TEASER'
                WHEN a.Bet_Type = 'MULTIPLE' then 'Parlay'
                WHEN a.Bet_Type = 'SINGLE' then 'Single'
                ELSE a.Bet_Type
          END AS bet_type,
          a.Num_Lines AS Legs,
          CASE WHEN total_price >= 2 THEN ROUND(((a.total_price-1)*100),0)
               ELSE ROUND((DIV0(-100,(a.total_price-1))),0)
          END as odds,
          bp.selection,
          bp.sport,
          CASE WHEN fp.bet_id is not null then 'Yes' ELSE 'No' END as fairplay,
          round((total_price * total_stake) - total_stake, 2) as possible_win,
          a.payout
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  left join (
              select bet_id,
                     RTRIM(LISTAGG(DISTINCT CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ')) WITHIN GROUP (ORDER BY CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ') DESC),' + ') AS selection,
                     RTRIM(LISTAGG(DISTINCT CONCAT(sport,' + ')) WITHIN GROUP (ORDER BY CONCAT(sport, ' + ') DESC),' + ') AS sport
              from FBG_SOURCE.OSB_SOURCE.BET_PARTS
              where date(convert_timezone('UTC','America/New_York', placed_time)) >= '2025-08-23'
              group by 1
             ) as bp
  on a.id = bp.bet_id
  
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
  on a.acco_id = cm.acco_id
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
  ON a.id = sfsa.bet_id
  
  LEFT JOIN avg_bets as ab
  ON a.acco_id = ab.acco_id
  
  LEFT JOIN fairplay as fp
  ON a.id = fp.bet_id
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('ACCEPTED', 'SETTLED')
  --and a.channel = 'INTERNET'
  --and (stake >= 1000 or a.payout > 2000)
  and cm.vip_host is not null
  and cm.vip_host not in ('VIP Host Holdout', 'Amelco Integration')
  and bp.selection is not null
  and date(convert_timezone('UTC','America/New_York', a.placed_time)) >= '2025-08-23'
) "Custom SQL Query"
