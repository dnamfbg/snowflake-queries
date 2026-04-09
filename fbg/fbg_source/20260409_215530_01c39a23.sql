-- Query ID: 01c39a23-0212-67a9-24dd-0703193c9903
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:55:30.207000+00:00
-- Elapsed: 29086ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."BETS" AS "BETS",
  CAST("Custom SQL Query"."BET_ID" AS TEXT) AS "BET_ID",
  "Custom SQL Query"."BET_TYPE" AS "BET_TYPE",
  "Custom SQL Query"."BOOST_PAYOUT" AS "BOOST_PAYOUT",
  "Custom SQL Query"."BOOST_TOKEN_PAYOUT" AS "BOOST_TOKEN_PAYOUT",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_ID" AS "EVENT_ID",
  "Custom SQL Query"."EVENT_TIME" AS "EVENT_TIME",
  "Custom SQL Query"."EXPECTED_HOLD_PCT" AS "EXPECTED_HOLD_PCT",
  "Custom SQL Query"."FREEBET_HANDLE" AS "FREEBET_HANDLE",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."KIOSKID" AS "KIOSKID",
  "Custom SQL Query"."KIOSK_TELLER" AS "KIOSK_TELLER",
  "Custom SQL Query"."LEGS" AS "LEGS",
  "Custom SQL Query"."LIVE_BET" AS "LIVE_BET",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME_ET" AS "PLACED_TIME_ET",
  "Custom SQL Query"."RETAIL_VENUE" AS "RETAIL_VENUE",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SETTLEMENT_TIME_ALK" AS "SETTLEMENT_TIME_ALK",
  "Custom SQL Query"."STAKEFACTOR" AS "STAKEFACTOR",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."Sport Category" AS "Sport Category",
  "Custom SQL Query"."VALUE_BAND" AS "VALUE_BAND",
  "Custom SQL Query"."VIP" AS "VIP",
  "Custom SQL Query"."WINNING_BONUS" AS "WINNING_BONUS"
FROM (
  WITH teasers AS (
    SELECT
        b.id AS bet_id,
        MAX(bp.teaser_adjust) AS teaser_value
    FROM FBG_SOURCE.OSB_SOURCE.BETS b
    JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp
      ON b.id = bp.bet_id
    WHERE b.channel = 'RETAIL'
      AND b.test = 0
      AND b.status IN ('ACCEPTED', 'SETTLED')
      AND bp.teaser_adjust IS NOT NULL
    GROUP BY b.id
  )
  
  SELECT 
      tm.wager_retail_card_id AS account_id, 
      tm.is_free_Bet_wager AS free_bet, 
      tm.event_id AS event_id, 
      tm.event_name AS event,
      tm.leg_event_time_est AS event_time,
      tm.leg_sport_category AS "Sport Category",
      tm.wager_state AS state, 
      tm.wager_status AS status,
      tm.wager_retail_venue_location AS retail_venue,
      tm.wager_id AS bet_id, 
      CASE WHEN t.bet_id IS NOT NULL THEN 'Teaser' ELSE tm.WAGER_BET_TYPE END AS bet_type, 
      tm.wager_kiosk AS kioskid, 
      tm.leg_market AS market, 
      tm.leg_selection AS selection, 
      CASE WHEN tm.wager_kiosk ILIKE '%Teller%' THEN 'Teller' ELSE 'Kiosk' END AS kiosk_teller, 
      tm.account_value_Band_as_of_placement AS value_band, 
      tm.is_live_bet_leg AS live_bet, 
      DATE_TRUNC('hour', tm.WAGER_PLACED_TIME_EST) AS placed_time_et, 
      DATE(tm.wager_settlement_time_alk) AS settlement_time_alk,
      tm.total_expected_hold_pct_by_wager AS expected_hold_pct, 
      tm.number_of_lines_by_wager AS legs, 
      tm.leg_stake_factor AS stakefactor, 
      cm.is_vip AS vip, 
      cm.current_value_band AS current_value_band,
      COUNT(DISTINCT tm.wager_id)/SUM(tm.number_of_lines_by_wager) bets,
      SUM(COALESCE(tm.total_cash_stake_by_legs, 0)) as stake, 
      SUM(COALESCE(tm.total_payout_by_legs, 0)) as payout, 
      SUM(COALESCE(tm.total_non_cash_stake_by_legs, 0)) as freebet_handle,
      SUM(COALESCE(tm.wager_boost_payout, 0)) as boost_payout, 
      SUM(COALESCE(tm.total_winnings_bonus_by_legs, 0)) as winning_bonus,
      SUM(COALESCE(tm.wager_boost_token_payout, 0)) AS boost_token_payout
  FROM FBG_ANALYTICS_ENGINEERING.TRADING.trading_sportsbook_mart tm
  LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.customer_mart cm 
      ON tm.wager_retail_card_id = cm.retail_card_id
  LEFT JOIN teasers t 
      ON t.bet_id = tm.wager_id
  WHERE 
      wager_channel = 'RETAIL'
      AND wager_status IN ('ACCEPTED', 'SETTLED')
      AND is_test_wager = 'FALSE'
  GROUP BY ALL
) "Custom SQL Query"
