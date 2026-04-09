-- Query ID: 01c39a47-0212-6e7d-24dd-070319449c8f
-- Database: FBG_SOURCE
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Executed: 2026-04-09T22:31:06.609000+00:00
-- Elapsed: 349843ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BONUS_PAYOUT" AS "BONUS_PAYOUT",
  "Custom SQL Query"."BOOST_PAYOUT" AS "BOOST_PAYOUT",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_ID" AS "EVENT_ID",
  "Custom SQL Query"."EVENT_TIME_ALK" AS "EVENT_TIME_ALK",
  "Custom SQL Query"."EVENT_TIME_ET" AS "EVENT_TIME_ET",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME_ALK" AS "PLACED_TIME_ALK",
  "Custom SQL Query"."PLACED_TIME_ET" AS "PLACED_TIME_ET",
  "Custom SQL Query"."SETTLEMENT_TIME_ALK" AS "SETTLEMENT_TIME_ALK",
  "Custom SQL Query"."SPORT_CATEGORY" AS "SPORT_CATEGORY",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."STAKE_UPDATED" AS "STAKE_UPDATED",
  "Custom SQL Query"."STATUS" AS "STATUS"
FROM (
  WITH fortuna_bets AS (
  SELECT 
  REGEXP_SUBSTR(overrides, 'betId=(\\d+)', 1, 1, 'e', 1) AS bet_id,
          REGEXP_SUBSTR(overrides, 'bonusBetAmt=(\\d+(\\.\\d+)?)', 1, 1, 'e', 1)::NUMBER(36,2) AS bonus_bet_amount
  from fbg_source.osb_source.account_bonuses
  where abs(bonus_bet_amount) > 0
  ),
  
  bets_enriched AS (
      SELECT
          b.*,
          /* Adjusted FREE_BET flag */
          CASE
              WHEN b.fancash_stake_amount > 0 AND b.free_bet = FALSE THEN TRUE
              ELSE b.free_bet
          END AS free_bet_eff,
  
          /* Adjusted TOTAL_STAKE using SFSA (bonus_bet_amount) when fancash stake is present */
          CASE
              WHEN b.fancash_stake_amount > 0 AND b.free_bet = FALSE
                  THEN COALESCE(sfsa.bonus_bet_amount, 0)
              ELSE b.total_stake
          END AS total_stake_eff
      FROM FBG_SOURCE.OSB_SOURCE.BETS AS b
      /* Needed for total_stake adjustment */
      LEFT JOIN fortuna_bets AS sfsa
          ON b.id = sfsa.bet_id
  )
  
  SELECT
      /* ids */
      b.id::VARCHAR AS bet_id,
  
      CASE
          WHEN b.channel = 'INTERNET' THEN b.acco_id::VARCHAR
          ELSE b.retail_card_id::VARCHAR
      END AS account_id,
  
      /* event / timing */
      bp.node_id::VARCHAR AS event_id,
      CONVERT_TIMEZONE('UTC', 'America/New_York',  bp.event_time)  AS event_time_et,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time)  AS event_time_alk,
      CONVERT_TIMEZONE('UTC', 'America/New_York',  b.placed_time)  AS placed_time_et,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)  AS placed_time_alk,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time) AS settlement_time_alk,
  
      /* financials using adjusted free_bet/total_stake */
      CASE
          WHEN b.free_bet_eff = FALSE THEN (b.payout / b.num_lines)
          ELSE 0
      END AS payout,
  
      b.pct_max_stake_used,
  
      CASE
          WHEN b.free_bet_eff = FALSE THEN (b.total_stake_eff / b.num_lines)
          ELSE 0
      END AS stake,
  
      /* stake_updated from your original logic, now using adjusted flags/amounts */
      CASE
          WHEN b.free_bet_eff = FALSE THEN (b.total_stake_eff / b.num_lines)
          ELSE NULL
      END AS stake_updated,
  
      CASE
          WHEN acc.colour_cat = 'YELLOW' THEN '0.51'
          ELSE COALESCE(COALESCE(acc.pre_match_stake_coef, acc.inplay_stake_coef), 1)
      END AS stakefactor,
  
      (b.winnings / b.num_lines) AS winnings,
  
      CASE
          WHEN b.status = 'SETTLED' AND b.free_bet_eff = TRUE
              THEN (b.payout / b.num_lines)
          ELSE 0
      END AS bonus_payout,
  
      /* flags and classifications */
      b.free_bet_eff::BOOLEAN AS free_bet,
      bp.live_bet::BOOLEAN    AS live_bet,
      ut.f1_loyalty_tier      AS current_value_band,
      bp.event,
      ut.current_state,
      bp.market,
      bp.selection,
      bp.selection_type       AS selection_type,
  
      /* include raw sport */
      bp.sport                AS sport,
  
      /* sport bucketing */
      CASE
          WHEN bp.comp ILIKE '%boost%' OR bp.market ILIKE '%boost%' OR bp.mrkt_type ILIKE '%boost%' THEN 'Odds Boost'
          WHEN bp.sport ILIKE '%Baseball%' AND bp.comp ILIKE '%MLB%'                                    THEN 'MLB'
          WHEN bp.comp ILIKE '%NFL%'                                                                     THEN 'NFL'
          WHEN bp.sport ILIKE '%Baseball%' AND bp.comp NOT ILIKE '%MLB%'                                THEN 'Other Baseball'
          WHEN bp.sport ILIKE '%American%Football%' AND bp.comp ILIKE '%NCAA%'                          THEN 'CFB'
          WHEN bp.sport ILIKE '%Soccer%'                                                                 THEN 'Soccer'
          WHEN bp.sport ILIKE '%Basketball%' AND bp.comp ILIKE 'NBA%'                                   THEN 'NBA'
          WHEN bp.sport ILIKE '%Basketball%' AND bp.comp ILIKE '%WNBA%'                                 THEN 'WNBA'
          WHEN bp.sport ILIKE '%Basketball%' AND (bp.comp ILIKE '%NCAA%' OR bp.comp = 'National Invitation Tournament' OR bp.comp ILIKE '%COLLEGE%')
                                                                                                        THEN 'NCAA Basketball'
          WHEN bp.sport ILIKE '%Basketball%' AND bp.comp NOT ILIKE '%NCAA%' AND bp.comp NOT LIKE '%NBA%' THEN 'Other Basketball'
          WHEN bp.sport ILIKE '%Ice%Hockey%' AND bp.comp ILIKE '%NHL%'                                  THEN 'NHL'
          WHEN bp.sport ILIKE '%Ice%Hockey%' AND bp.comp NOT ILIKE '%NHL%'                              THEN 'Other Hockey'
          WHEN bp.sport ILIKE '%Table%Tennis%'                                                           THEN 'Table Tennis'
          WHEN UPPER(bp.sport) = 'TENNIS'                                                                THEN 'Tennis'
          WHEN bp.comp ILIKE '%UFC%' OR bp.sport ILIKE '%MMA%'                                          THEN 'MMA'
          WHEN bp.sport ILIKE '%NASCAR%' OR bp.comp ILIKE '%NASCAR%' OR bp.sport = 'MOTOR_SPORTS'       THEN 'Motorsports'
          WHEN bp.sport ILIKE '%Boxing%'                                                                 THEN 'Boxing'
          WHEN bp.sport ILIKE '%Golf%'                                                                   THEN 'Golf'
          WHEN bp.sport ILIKE '%Ice%Hockey%' OR bp.sport ILIKE '%Basketball%' OR bp.sport ILIKE '%American Football%' OR bp.sport ILIKE '%Baseball%'
                                                                                                        THEN bp.comp
          ELSE bp.sport
      END AS sport_category,
  
      j.jurisdiction_code AS state,
      b.status            AS status,
  
      /* boost_payout with adjusted free_bet / total_stake */
      CASE
          WHEN b.payout > 0
               AND b.free_bet_eff = FALSE
               AND b.payout >= b.total_stake_eff
               AND CASE
                       WHEN COALESCE(b.odds_boost_bonus_winnings, 0) > 0 THEN 1
                       WHEN b.odds_boost_bonus = TRUE THEN 1
                       ELSE 0
                   END = 1
               AND b.result != 4
          THEN (
              (
                  (b.payout / b.total_stake_eff)
                  - (
                      (
                          ((PARSE_JSON(p.data):Bonus:oddsBoost:boostPercentage) / 100)
                          + (b.payout / b.total_stake_eff)
                      ) / (
                          ((PARSE_JSON(p.data):Bonus:oddsBoost:boostPercentage) / 100) + 1
                      )
                  )
              ) * b.total_stake_eff
          ) / b.num_lines
          ELSE 0
      END
      +
      CASE
          WHEN b.free_bet_eff = FALSE
               AND b.payout > 0
               AND b.result != 4
               AND wp.non_boosted_price IS NOT NULL
               AND wp.non_boosted_price < COALESCE(original_price, price)
               AND COALESCE(original_price, price) <= price
          THEN (
              (
                  (COALESCE(original_price, price)) - wp.non_boosted_price
              ) * (b.total_stake_eff / b.num_lines)
          ) * (
              b.payout / (
                  b.total_stake_eff * CASE
                      WHEN b.free_bet_eff = TRUE THEN b.total_price - 1
                      ELSE b.total_price
                  END
              )
          )
          ELSE 0
      END AS boost_payout
  
  FROM bets_enriched AS b
  INNER JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS                    AS bp   ON bp.bet_id = b.id
  LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS              AS cvb  ON cvb.acco_id = b.acco_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS                     AS acc  ON acc.id = b.acco_id
  INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart  AS ut   ON ut.acco_id = acc.id
  INNER JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS                AS j    ON j.id = b.jurisdictions_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.Bonus_Campaigns              AS p    ON p.id = b.bonus_campaign_id
  LEFT JOIN FBG_ANALYTICS.TRADING.WAS_PRICE                    AS wp   ON bp.instrument_id = wp.instrument_id
  
  WHERE
      acc.test = 0
      AND b.channel = 'INTERNET'
      AND b.status IN ('ACCEPTED', 'SETTLED', 'REJECTED')
      /* use raw timestamps in WHERE (not select aliases) */
      AND (
          CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time) >= DATEADD(day, -8, CURRENT_DATE)
          OR CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)    >= DATEADD(day, -8, CURRENT_DATE)
          OR CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time)    >= DATEADD(day, -8, CURRENT_DATE)
      )
  
  /* Snowflake supports GROUP BY ALL to group by every non-aggregated select item */
  GROUP BY ALL
) "Custom SQL Query"
