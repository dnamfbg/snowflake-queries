-- Query ID: 01c399c8-0212-6e7d-24dd-07031928251b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:24:47.171000+00:00
-- Elapsed: 1330ms
-- Environment: FBG

WITH old AS (
    SELECT acco_id, game_id, platform_id, state, total_bet_count, cash_bet_count, cash_bet_round_count
    FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
    WHERE settled_date_alk = '2026-01-21'
),
new AS (
    SELECT acco_id, game_id, platform_id, state, total_bet_count, cash_bet_count, cash_bet_round_count
    FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
    WHERE settled_date_alk = '2026-01-21'
)
SELECT o.acco_id, o.game_id, o.platform_id, o.state,
       o.total_bet_count AS old_total, n.total_bet_count AS new_total,
       o.cash_bet_count AS old_cash, n.cash_bet_count AS new_cash,
       o.cash_bet_round_count AS old_rounds, n.cash_bet_round_count AS new_rounds
FROM old o
JOIN new n ON o.acco_id = n.acco_id AND o.game_id = n.game_id 
    AND o.platform_id = n.platform_id AND EQUAL_NULL(o.state, n.state)
WHERE o.total_bet_count != n.total_bet_count
   OR o.cash_bet_count != n.cash_bet_count
   OR o.cash_bet_round_count != n.cash_bet_round_count
