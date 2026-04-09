-- Query ID: 01c39a27-0212-644a-24dd-0703193d8827
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:59:01.975000+00:00
-- Elapsed: 8861ms
-- Environment: FBG

WITH market_map AS (
    SELECT 'Points'           AS incident_type, 'BASKETBALL:FT:PROPPTS'   AS ou_market, 'BASKETBALL:FT:PROPPTSTG'  AS alt_market UNION ALL
    SELECT 'Rebounds',                           'BASKETBALL:FT:PROPREB',               'BASKETBALL:FT:PROPREBTG'              UNION ALL
    SELECT 'Assists',                            'BASKETBALL:FT:PROPAST',               'BASKETBALL:FT:PROPASTTG'
),

base AS (
    SELECT
        m.incident_type AS prop_type,
        p.FBG,
        p.PINNACLE,
        t.WAGER_ID,
        t.WAGER_STATUS,
        t.TOTAL_CASH_STAKE_BY_LEGS,
        t.TOTAL_CASH_WAGER_PAYOUT_BY_LEGS,
        t.TRADING_WIN,
        CASE
            WHEN p.PINNACLE IS NULL OR p.PINNACLE = 0 THEN NULL
            ELSE t.TOTAL_CASH_STAKE_BY_LEGS
                - (t.TOTAL_CASH_WAGER_PAYOUT_BY_LEGS * (p.PINNACLE / NULLIF(p.FBG, 0)))
        END AS hypothetical_trading_win_at_pinnacle
    FROM market_map m
    JOIN FBG_UNITY_CATALOG.QUANTS.price_alignment_history p
        ON p.INCIDENT_TYPE = m.incident_type
    JOIN FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART t
        ON t.LEG_MARKET_TYPE IN (m.ou_market, m.alt_market)
        AND p.fixture_id = REPLACE(t.event_system_reference, ':', '-')
        AND p.player_participant_id = REGEXP_SUBSTR(t.leg_market_sub_type, '[0-9]+')
        AND p.line = CASE
            WHEN t.LEG_MARKET_TYPE = m.alt_market
                AND CAST(REGEXP_REPLACE(t.leg_selection, '[^0-9\\.]', '') AS DOUBLE) = FLOOR(CAST(REGEXP_REPLACE(t.leg_selection, '[^0-9\\.]', '') AS DOUBLE))
                THEN CAST(REGEXP_REPLACE(t.leg_selection, '[^0-9\\.]', '') AS DOUBLE) - 0.5
            ELSE CAST(REGEXP_REPLACE(t.leg_selection, '[^0-9\\.]', '') AS DOUBLE)
        END
        AND (t.LEG_MARKET_TYPE != m.alt_market OR p.SELECTION = 'Over')
        AND (t.LEG_MARKET_TYPE != m.ou_market OR p.SELECTION = SPLIT_PART(t.leg_selection, ' ', 1))
    WHERE p.EVENT_SPORT = 'BASKETBALL'
      AND p.MARKET_TYPE = 'PlayerPropsOverUnder'
      AND p.PERIOD_TYPE = 'FullTime'
      AND p.IS_INPLAY = 'TRUE'
      AND t.wager_placed_time_utc BETWEEN p.push_timestamp AND p.end_timestamp
      AND t.leg_odds = p.fbg
      AND t.WAGER_BET_TYPE = 'SINGLE'
      AND t.WAGER_CHANNEL = 'INTERNET'
      AND t.wager_status = 'SETTLED'
      AND p.FBG IS NOT NULL AND p.FBG <> 0
      AND p.PINNACLE IS NOT NULL
      AND t.WAGER_RESULT != 'CASHOUT'
      AND t.total_non_cash_stake_by_legs = 0
      AND t.is_test_wager = 0
      AND t.event_league = 'NBA'
      AND DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', t.leg_event_time_utc)) BETWEEN '2025-10-21' AND '2026-04-09'
      AND t.leg_market_type IN (
          'BASKETBALL:FT:PROPPTS', 'BASKETBALL:FT:PROPPTSTG',
          'BASKETBALL:FT:PROPREB', 'BASKETBALL:FT:PROPREBTG',
          'BASKETBALL:FT:PROPAST', 'BASKETBALL:FT:PROPASTTG'
      )
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY t.leg_id
        ORDER BY p.push_timestamp DESC
    ) = 1
)

SELECT
    prop_type,
    CASE
        WHEN PINNACLE = 0 THEN 'PIN Suspended'
        WHEN FBG > PINNACLE THEN 'FBG Above Pinnacle'
        WHEN FBG < PINNACLE THEN 'FBG Below Pinnacle'
        ELSE 'FBG Equal to Pinnacle'
    END AS fbg_vs_pinnacle,

    SUM(total_cash_stake_by_legs) AS Turnover,
    COUNT(DISTINCT wager_id) AS Bet_Count,
    SUM(trading_win) / NULLIF(SUM(total_cash_stake_by_legs), 0) AS TR_Margin,
    SUM(trading_win) AS TR_Win,

    SUM(hypothetical_trading_win_at_pinnacle)
        / NULLIF(SUM(CASE WHEN PINNACLE != 0 THEN total_cash_stake_by_legs END), 0) AS PIN_TR_Margin,
    SUM(hypothetical_trading_win_at_pinnacle) AS PIN_TR_Win,

    SUM(trading_win) - SUM(hypothetical_trading_win_at_pinnacle) AS TR_Win_Difference,
    COUNT(DISTINCT CASE WHEN PINNACLE = 0 THEN wager_id END) AS Suspended_Count
FROM base
GROUP BY prop_type, fbg_vs_pinnacle
ORDER BY prop_type, fbg_vs_pinnacle;
