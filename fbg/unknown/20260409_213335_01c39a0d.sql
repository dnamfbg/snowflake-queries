-- Query ID: 01c39a0d-0212-67a9-24dd-07031937e28b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:33:35.240000+00:00
-- Elapsed: 172074ms
-- Environment: FBG

WITH
margin_ladder AS (
  SELECT
    CAST(lowerbound_price_leg AS NUMBER(38,12)) AS lowerbound_price_leg,
    CAST(upperbound_price_leg AS NUMBER(38,12)) AS upperbound_price_leg,
    new_bet_adjustment
  FROM fbg_analytics.trading.generic_margin_applier_v2
  WHERE build_a_bet = FALSE
),

was_price AS (
  SELECT instrument_id, MAX(non_boosted_price) AS non_boosted_price
  FROM (
    SELECT
      bp.instrument_id,
      MAX(bp.selection) AS selection,
      MIN(COALESCE(bp.original_price, bp.price)) AS price,
      POSITION('(was', LOWER(bp.selection)) AS abc,
      REPLACE(SUBSTR(bp.selection, abc+5, 6), ' ', '') AS american_odds,
      SUBSTR(american_odds, 1, 1) AS neg_pos,
      CASE
        WHEN abc = 0 THEN '0'
        WHEN neg_pos NOT IN ('-','+') THEN '0'
        ELSE REPLACE(SUBSTR(american_odds, 2, 4), ')', '')
      END AS odds_value,
      TO_DOUBLE(CASE WHEN LOWER(odds_value) LIKE '%x%' THEN '0' ELSE odds_value END) AS odds_value_2,
      CASE
        WHEN odds_value_2 = 0 THEN price
        WHEN neg_pos = '+' THEN ((1/100)*odds_value)+1
        WHEN neg_pos = '-' THEN (1-(100/(odds_value*-1)))
      END::NUMBER(38,12) AS non_boosted_price
    FROM FBG_SOURCE.OSB_SOURCE.BETS b
    JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
    WHERE b.channel = 'INTERNET'
      AND DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', b.settlement_time))
          BETWEEN DATEADD(day,-2, '2026-04-02'::DATE)
              AND '2026-04-02'::DATE
      AND b.free_bet = FALSE
      AND b.odds_boost_bonus = FALSE
      AND (
            CASE
              WHEN bp.comp ILIKE '%boost%' THEN 1
              WHEN bp.market ILIKE '%boost%' THEN 1
              WHEN bp.mrkt_type ILIKE '%boost%' THEN 1
              ELSE 0
            END
          ) = 1
    GROUP BY ALL
  )
  GROUP BY ALL
),

nb_base AS (
  SELECT
    b.id AS bet_id,
    CAST(
      CASE
        WHEN wp.non_boosted_price IS NOT NULL THEN wp.non_boosted_price
        WHEN b.odds_boost_bonus = TRUE THEN b.price_at_placement
        ELSE b.total_price
      END
      AS NUMBER(38,12)
    ) AS non_boosted_bet_price,
    CAST(b.total_price AS NUMBER(38,12)) AS boosted_bet_price,
    CASE
      WHEN LEAST(a.pre_match_stake_coef, a.inplay_stake_coef) <= 0.3 THEN 1
      WHEN a.colour_cat = 'YELLOW' THEN 2
      ELSE 0
    END AS customer_flag
  FROM FBG_SOURCE.OSB_SOURCE.BETS b
  JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id
  LEFT JOIN was_price wp ON bp.instrument_id = wp.instrument_id
  WHERE a.test = 0
    AND b.status <> 'VOID'
    AND DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', b.settlement_time))
        BETWEEN DATEADD(day,-2, '2026-04-02'::DATE)
            AND '2026-04-02'::DATE
    AND b.status = 'SETTLED'
),

nonboostedbetprice AS (
  SELECT
    nb.bet_id,
    nb.non_boosted_bet_price,
    nb.boosted_bet_price,
    nb.customer_flag,
    MAX(ml.new_bet_adjustment) AS new_bet_adjustment
  FROM nb_base nb
  LEFT JOIN margin_ladder ml
       ON nb.non_boosted_bet_price >  ml.lowerbound_price_leg
      AND nb.non_boosted_bet_price <= ml.upperbound_price_leg
  GROUP BY ALL
),

basic_assumption AS (
  SELECT
    bet_id,
    MAX(non_boosted_bet_price) AS non_boosted_bet_price,
    MAX(boosted_bet_price)     AS boosted_bet_price,
    MAX(CASE WHEN customer_flag = 1 THEN -0.05
             WHEN customer_flag = 2 THEN 0
             ELSE new_bet_adjustment END) AS xtradingwinpct,
    MAX(
      CASE
        WHEN customer_flag = 1 AND DIV0(1, (1 / non_boosted_bet_price) * (1 - -0.05)) = 0 THEN non_boosted_bet_price
        WHEN customer_flag = 1 THEN GREATEST(1.000001, 1 / ((1 / non_boosted_bet_price) * (1 - -0.05)))
        WHEN customer_flag = 2 THEN non_boosted_bet_price
        WHEN DIV0(1, (1 / non_boosted_bet_price) * (1 - new_bet_adjustment)) = 0 THEN non_boosted_bet_price
        ELSE 1 / ((1 / non_boosted_bet_price) * (1 - new_bet_adjustment))
      END
    ) AS true_bet_price
  FROM nonboostedbetprice
  GROUP BY ALL
),

xpct AS (
  SELECT
    bet_id,
    xtradingwinpct,
    1 - (boosted_bet_price / true_bet_price) AS xggrpct
  FROM basic_assumption
),

/* ---------- All filters live here ---------- */
base_legs AS (
  SELECT
    bp.comp                          AS event_league,
    bp.sport                         AS event_sport,
    bp.node_id                       AS event_id,
    bp.event                         AS event_name,
    CONVERT_TIMEZONE('UTC','America/New_York', bp.event_time) AS event_time_et,
    b.id                             AS wager_id,
    b.acco_id                        AS account_id,
    b.status                         AS wager_status,
    b.channel                        AS wager_channel,
    COALESCE(bp.live_bet, FALSE)     AS is_live_bet_leg,
    b.bet_type                       AS wager_bet_type,
    COALESCE(b.build_a_bet, FALSE)   AS is_sgp_leg,
    b.num_lines,
    b.total_stake,
    b.payout,
    b.free_bet,
    b.total_price,
    fem.expected_hold_pct,
    fem.total_expected_hold_pct,
    xp.xggrpct,
    xp.xtradingwinpct
  FROM FBG_SOURCE.OSB_SOURCE.BETS b
  JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id
  LEFT JOIN FBG_ANALYTICS.TRADING.FCT_EXPECTED_MARGIN fem ON b.id = fem.id
  LEFT JOIN xpct xp ON b.id = xp.bet_id
  
-- FILTERS  
  WHERE a.test = 0
    AND b.status <> 'VOID'
    AND b.status <> 'REJECTED'
    --AND b.channel = 'INTERNET'
    AND COALESCE(b.free_bet, FALSE) = FALSE
    AND bp.comp ILIKE '%MLB%'
    AND DATE(CONVERT_TIMEZONE('UTC','America/New_York', bp.event_time)) = '2026-04-09'
    -- AND bp.node_id = 2392656
    --AND bp.live_bet = TRUE
),

leg_amounts AS (
  SELECT
    *,
    (total_stake / NULLIF(num_lines,0)) AS total_stake_by_leg,
    (CASE WHEN free_bet = FALSE THEN (total_stake / NULLIF(num_lines,0)) ELSE 0 END) AS total_cash_stake_by_legs,
    (CASE WHEN free_bet = FALSE THEN (total_stake / NULLIF(num_lines,0)) - (payout / NULLIF(num_lines,0)) ELSE 0 END) AS trading_win_by_leg,
    (total_stake / NULLIF(num_lines,0)) * COALESCE(total_expected_hold_pct, xggrpct) AS expected_trading_win_by_legs,
    (CASE WHEN is_live_bet_leg = TRUE AND wager_status = 'SETTLED' AND free_bet = FALSE
          THEN (total_stake / NULLIF(num_lines,0)) ELSE 0 END) AS live_cash_stake_settled_by_legs,
    (CASE WHEN is_live_bet_leg = TRUE AND wager_status = 'SETTLED' AND free_bet = FALSE
          THEN ((total_stake / NULLIF(num_lines,0)) - (payout / NULLIF(num_lines,0))) ELSE 0 END) AS live_trading_win_by_legs
  FROM base_legs)


SELECT
  event_league,
  event_sport,
  event_id,
  MAX(event_name)    AS event_name,
  MAX(event_time_et) AS event_start_time,
  ROUND(SUM(total_cash_stake_by_legs), 2) AS cash_handle,
  ROUND(
    SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END)
    / NULLIF(SUM(total_cash_stake_by_legs),0), 3
  ) AS pct_settled_handle,

  ROUND(SUM(CASE WHEN wager_status = 'SETTLED' THEN trading_win_by_leg ELSE 0 END), 3) AS settled_trading_win,
  ROUND(
    SUM(CASE WHEN wager_status = 'SETTLED' THEN trading_win_by_leg ELSE 0 END)
    / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END),0), 3
  ) AS pct_sTW,

  ROUND(
    SUM(CASE WHEN wager_status = 'SETTLED' THEN expected_trading_win_by_legs ELSE 0 END)
    / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END),0), 3
  ) AS pct_XTW,

  ROUND(SUM(live_cash_stake_settled_by_legs) / NULLIF(SUM(total_cash_stake_by_legs),0), 2) AS pct_live_handle,
  ROUND(SUM(live_cash_stake_settled_by_legs), 2) AS live_handle,
  ROUND(SUM(live_trading_win_by_legs), 2) AS live_trading_win,
  ROUND(
    SUM(live_trading_win_by_legs)
    / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END),0), 3
  ) AS pct_live_tw,
  ROUND(
    SUM(CASE WHEN is_live_bet_leg = TRUE AND wager_status = 'SETTLED' THEN expected_trading_win_by_legs ELSE 0 END)
    / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END),0), 3
  ) AS pct_live_xtw,

  COUNT(DISTINCT account_id) AS total_unique_users,
  COUNT(DISTINCT wager_id)   AS total_bets,

  ROUND(
    SUM(CASE WHEN UPPER(wager_bet_type) = 'SINGLE' AND free_bet = FALSE THEN total_stake_by_leg ELSE 0 END)
    / NULLIF(SUM(total_cash_stake_by_legs),0), 2
  ) AS pct_single_handle,
  ROUND(
    SUM(CASE WHEN (UPPER(wager_bet_type) <> 'SINGLE' AND COALESCE(is_sgp_leg,FALSE)=FALSE) AND free_bet = FALSE
             THEN total_stake_by_leg ELSE 0 END)
    / NULLIF(SUM(total_cash_stake_by_legs),0), 2
  ) AS pct_parlay_handle,
  ROUND(
    SUM(CASE WHEN COALESCE(is_sgp_leg,FALSE)=TRUE AND free_bet = FALSE THEN total_stake_by_leg ELSE 0 END)
    / NULLIF(SUM(total_cash_stake_by_legs),0), 2
  ) AS pct_sgp_handle
FROM leg_amounts
GROUP BY event_league, event_sport, event_id
ORDER BY cash_handle DESC;
