-- Query ID: 01c399c9-0212-6e7d-24dd-070319282967
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:25:52.487000+00:00
-- Elapsed: 14041ms
-- Environment: FBG

SELECT 
    COUNT(CASE WHEN ABS(o.total_stake - n.total_stake_usd) > 0.01 THEN 1 END) AS stake_diffs,
    COUNT(CASE WHEN ABS(o.total_payout - n.total_payout_usd) > 0.01 THEN 1 END) AS payout_diffs,
    COUNT(CASE WHEN ABS(o.total_void - n.total_void_usd) > 0.01 THEN 1 END) AS void_diffs,
    COUNT(CASE WHEN ABS(o.ggr - n.ggr_usd) > 0.01 THEN 1 END) AS ggr_diffs,
    COUNT(CASE WHEN ABS(o.ngr - n.ngr_usd) > 0.01 THEN 1 END) AS ngr_diffs,
    COUNT(CASE WHEN ABS(o.cash_bet_stake - n.cash_bet_stake_usd) > 0.01 THEN 1 END) AS cash_stake_diffs,
    COUNT(CASE WHEN ABS(o.cash_bet_payout - n.cash_bet_payout_usd) > 0.01 THEN 1 END) AS cash_payout_diffs,
    COUNT(CASE WHEN ABS(o.freespin_bet_stake - n.freespin_bet_stake_usd) > 0.01 THEN 1 END) AS fs_stake_diffs,
    COUNT(CASE WHEN ABS(o.casino_credit_bet_stake - n.casino_credit_bet_stake_usd) > 0.01 THEN 1 END) AS cc_stake_diffs
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg o
JOIN fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd n
    ON o.acco_id = n.acco_id AND o.game_id = n.game_id 
    AND o.platform_id = n.platform_id AND EQUAL_NULL(o.state, n.state)
    AND o.settled_date_alk = n.settled_date_alk
WHERE o.settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
