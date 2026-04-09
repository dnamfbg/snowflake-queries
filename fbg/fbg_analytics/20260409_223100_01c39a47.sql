-- Query ID: 01c39a47-0212-6dbe-24dd-070319447c5f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:31:00.123000+00:00
-- Elapsed: 7809ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_NGR" AS "BET_NGR",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."BET_TYPE" AS "BET_TYPE",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LEGS" AS "LEGS",
  "Custom SQL Query"."ODDS" AS "ODDS",
  "Custom SQL Query"."PLACED_TIME_EST" AS "PLACED_TIME_EST",
  "Custom SQL Query"."REAX_FT_SM" AS "REAX_FT_SM",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SETTLED_DATE" AS "SETTLED_DATE",
  "Custom SQL Query"."SETTLED_TIME_EST" AS "SETTLED_TIME_EST",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  with sb_bets as(
  select
  distinct a.bet_id
  from fbg_source.osb_source.bet_parts a
  where 1=1
  and (a.event = 'New England Patriots v Seattle Seahawks' or a.event ilike '%Super Bowl%')
  and a.event_time >= '2026-02-08 00:00:00.000'
  and a.event_time <= '2026-02-18 00:00:00.000'
  ),
  
  temp1 as(
  
  select  a.acco_id,
          cm.f1_loyalty_tier,
          cm.vip_host,
          cm.lead_owner,
          CASE WHEN ui.vip_host is not null then NULL
               WHEN ui.reactivation_entry_date is not null and reactivation_end_date is null then 'Reactivation'
               WHEN ui.is_currently_fast_track = TRUE then 'Fast Track'
               WHEN ui.is_status_match = TRUE then 'Status Match'
               ELSE NULL
          END as reax_ft_sm,
          convert_timezone('UTC','America/New_York', a.placed_time) as placed_time_est,
          convert_timezone('UTC','America/New_York', a.settlement_time) as settled_time_est,
          DATE(convert_timezone('UTC','America/Anchorage', a.settlement_time)) as settled_date,
          a.id as bet_id,
          CASE WHEN a.status = 'ACCEPTED' THEN 'Open'
               WHEN a.status = 'SETTLED' AND a.result = 4 THEN 'Cashout'
               WHEN a.status = 'SETTLED' AND a.payout = 0 THEN 'Loss'
               WHEN a.status = 'SETTLED' AND a.payout > 0 THEN 'Win'
          END as bet_status,
          a.total_stake as stake,
          CASE
              WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
              ELSE a.total_stake
          END 
          - 
          a.payout AS bet_ngr,
          CASE WHEN a.Build_A_Bet = 't' then 'SGP' 
                WHEN a.Teaser_Price IS NOT NULL THEN 'TEASER'
                WHEN a.Bet_Type = 'MULTIPLE' then 'Parlay'
                WHEN a.Bet_Type = 'SINGLE' then 'Single'
                ELSE a.Bet_Type
          END AS bet_type,
          a.Num_Lines AS Legs,
          CASE WHEN total_price >= 2 THEN ROUND(((a.total_price-1)*100),0)
               ELSE ROUND((-100/(a.total_price-1)),0)
          END as odds,
          bp.selection,
          --bp.sport
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  left join (
              select a.bet_id,
                     RTRIM(LISTAGG(DISTINCT CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ')) WITHIN GROUP (ORDER BY CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ') DESC),' + ') AS selection,
                     RTRIM(LISTAGG(DISTINCT CONCAT(sport,' + ')) WITHIN GROUP (ORDER BY CONCAT(sport, ' + ') DESC),' + ') AS sport
              from FBG_SOURCE.OSB_SOURCE.BET_PARTS a
              inner join sb_bets sb
                  on a.bet_id = sb.bet_id
              where 1=1
              group by 1
             ) as bp
  on a.id = bp.bet_id
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
      ON a.id = sfsa.bet_id
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
      on a.acco_id = cm.acco_id
  
  LEFT JOIN fbg_analytics.vip.vip_user_info ui
      on a.acco_id = ui.acco_id
  
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('SETTLED', 'ACCEPTED')
  and a.channel = 'INTERNET'
  and a.total_stake > 10000
  and bp.selection is not null
  and cm.current_value_band <> 'Super VIP'
  )
  select * from temp1
) "Custom SQL Query"
