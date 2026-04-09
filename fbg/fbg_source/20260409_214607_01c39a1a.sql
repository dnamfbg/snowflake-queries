-- Query ID: 01c39a1a-0212-6cb9-24dd-0703193ab973
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: STRATEGY_XL_WH
-- Executed: 2026-04-09T21:46:07.946000+00:00
-- Elapsed: 33888ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BONUS_PAYOUT" AS "BONUS_PAYOUT",
  "Custom SQL Query"."BOOST_PAYOUT" AS "BOOST_PAYOUT",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_ID" AS "EVENT_ID",
  "Custom SQL Query"."EVENT_TIME_ET" AS "EVENT_TIME_ET",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME_ET" AS "PLACED_TIME_ET",
  "Custom SQL Query"."SETTLEMENT_TIME_ALK" AS "SETTLEMENT_TIME_ALK",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."Sport_Category" AS "Sport_Category",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  SELECT
          b.id::varchar AS bet_id,
  
          CASE
              WHEN b.channel = 'INTERNET' THEN b.acco_id::varchar
              ELSE b.retail_card_id::varchar
          END AS account_id,
          UT.vip_host,
          bp.node_id::varchar AS event_id,
          CONVERT_TIMEZONE(
              'UTC', 'America/New_York', bp.event_time
          ) AS event_time_et,
          CONVERT_TIMEZONE(
              'UTC', 'America/New_York', b.placed_time
          ) AS placed_time_et,
          CONVERT_TIMEZONE(
              'UTC', 'America/Anchorage', b.settlement_time
          ) AS settlement_time_alk,  
          CASE
              WHEN free_bet != 'TRUE' THEN(b.payout / b.num_lines)
              ELSE 0
          END AS payout,
          b.pct_max_stake_used,
          CASE
              WHEN free_bet != 'TRUE' THEN (b.total_stake / b.num_lines)
              ELSE 0
          END AS stake,
          CASE
              WHEN acc.colour_cat = 'YELLOW' THEN '0.51'
              ELSE COALESCE(
                  COALESCE(acc.pre_match_stake_coef, acc.inplay_stake_coef),
                  1
              )
          END AS stakefactor,
          (b.winnings / b.num_lines) AS winnings,
          CASE
              WHEN b.status = 'SETTLED'
                  AND free_bet = 'TRUE' THEN (b.payout / b.num_lines)
              ELSE 0
          END AS Bonus_Payout,
          free_bet::boolean AS free_bet,
          bp.live_bet::boolean AS live_bet,
          ut.f1_loyalty_tier AS current_value_band,
          bp.event,
  UT.Current_State,
          bp.market,
          bp.selection,
          bp.selection_type AS selection_type,
  
          CASE
              WHEN comp ILIKE '%boost%'
                  OR market ILIKE '%boost%'
                  OR bp.mrkt_type ILIKE '%boost%' THEN 'Odds Boost'
              WHEN bp.sport ILIKE '%Baseball%'
                  AND bp.comp ILIKE '%MLB%' THEN 'MLB'
              WHEN bp.comp ILIKE '%NFL%' THEN 'NFL'
              WHEN bp.sport ILIKE '%Baseball%'
                  AND bp.comp NOT ILIKE '%MLB%' THEN 'Other Baseball'
              WHEN bp.sport ILIKE '%American%Football%'
                  AND bp.comp ILIKE '%NCAA%' THEN 'CFB'
              WHEN bp.sport ILIKE '%Soccer%' THEN 'Soccer'
              WHEN bp.sport ILIKE '%Basketball%'
                  AND bp.comp ILIKE 'NBA%' THEN 'NBA'
              WHEN bp.sport ILIKE '%Basketball%'
                  AND bp.comp ILIKE '%WNBA%' THEN 'WNBA'
              WHEN bp.sport ILIKE '%Basketball%'
                  AND (
                      bp.comp ILIKE '%NCAA%'
                      OR bp.comp = 'National Invitation Tournament'
                      OR bp.comp ILIKE '%COLLEGE%'
                  ) THEN 'NCAA Basketball'
              WHEN bp.sport ILIKE '%Basketball%'
                  AND bp.comp NOT ILIKE '%NCAA%'
                  AND bp.comp NOT LIKE '%NBA%' THEN 'Other Basketball'
              WHEN bp.sport ILIKE '%Ice%Hockey%'
                  AND bp.comp ILIKE '%NHL%' THEN 'NHL'
              WHEN bp.sport ILIKE '%Ice%Hockey%'
                  AND bp.comp NOT ILIKE '%NHL%' THEN 'Other Hockey'
              WHEN bp.sport ILIKE '%Table%Tennis%' THEN 'Table Tennis'
              WHEN UPPER(bp.sport) = 'TENNIS' THEN 'Tennis'
              WHEN bp.comp ILIKE '%UFC%' THEN 'MMA'
              WHEN bp.sport ILIKE '%MMA%' THEN 'MMA'
              WHEN bp.sport ILIKE '%NASCAR%'
                  OR bp.comp ILIKE '%NASCAR%' THEN 'Motorsports'
              WHEN bp.sport = 'MOTOR_SPORTS' THEN 'Motorsports'
              WHEN bp.sport ILIKE '%Boxing%' THEN 'Boxing'
              WHEN bp.sport ILIKE '%Golf%' THEN 'Golf'
              WHEN bp.sport ILIKE '%Ice%Hockey%'
                  OR bp.sport ILIKE '%Basketball%'
                  OR bp.sport ILIKE '%American Football%'
                  OR bp.sport ILIKE '%Baseball%' THEN bp.comp
              ELSE bp.sport
          END AS "Sport_Category", 
          j.jurisdiction_code AS state,
          b.status AS status,
          CASE
              WHEN b.payout > 0
                  AND FREE_BET = FALSE
                  AND b.payout >= b.total_stake
                  AND CASE
                      WHEN COALESCE(b.odds_boost_bonus_winnings, 0) > 0 THEN 1
                      WHEN b.odds_boost_bonus = TRUE THEN 1
                      ELSE 0
                  END = 1
                  AND b.result != 4 THEN (
                      (
                          (b.payout / b.total_stake) - (
                              (
                                  (
                                      (
                                          PARSE_JSON(
                                              p.data
                                          ) :Bonus:oddsBoost:boostPercentage
                                      ) / 100
                                  ) + (b.payout / b.total_stake)
                              ) / (
                                  (
                                      (
                                          PARSE_JSON(
                                              p.data
                                          ) :Bonus:oddsBoost:boostPercentage
                                      ) / 100
                                  ) + 1
                              )
                          )
                      ) * b.total_stake
                  ) / b.num_lines
              ELSE 0
          END + CASE
              WHEN free_bet = FALSE
                  AND payout > 0
                  AND b.result != 4
                  AND non_boosted_price IS NOT NULL
                  AND non_boosted_price < COALESCE(original_price, price)
                  AND COALESCE(original_price, price) <= price THEN (
                      (
                          (
                              COALESCE(original_price, price)
                          ) - non_boosted_price
                      ) * (total_stake / num_lines)
                  ) * (
                      payout / (
                          total_stake * CASE
                              WHEN free_bet = TRUE THEN total_price - 1
                              ELSE total_price
                          END
                      )
                  )
              ELSE 0
          END AS boost_payout
      FROM
          FBG_SOURCE.OSB_SOURCE.Bets AS b
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS AS bp ON bp.bet_id = b.id
      LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS AS cvb ON cvb.acco_id = b.acco_id
      LEFT JOIN
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS AS acc ON acc.id = b.acco_id
  LEFT JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart UT
  ON UT.Acco_ID = ACC.ID
      LEFT JOIN
          FBG_SOURCE.OSB_SOURCE.JURISDICTIONS AS j ON
              j.id = b.jurisdictions_id
  
     LEFT JOIN
          FBG_SOURCE.OSB_SOURCE.Bonus_Campaigns AS p ON
              p.id = b.bonus_campaign_id
      LEFT JOIN
          FBG_ANALYTICS.TRADING.WAS_PRICE AS wp ON bp.instrument_id = wp.instrument_id
      WHERE
          acc.test = 0
          and b.channel = 'INTERNET'
          and b.status IN ('ACCEPTED','SETTLED','REJECTED')
          and (ut.is_vip = TRUE or ut.is_casino_vip = TRUE or ut.vip_host is not null)
          and (settlement_time_alk >= dateadd(day,-8,current_date) OR placed_time_et >= dateadd(day,-8,current_date) OR event_time_et >= dateadd(day,-8,current_date)  )
  GROUP BY ALL
) "Custom SQL Query"
