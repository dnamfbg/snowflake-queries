-- Query ID: 01c399c9-0212-6b00-24dd-07031927edb7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:25:34.734000+00:00
-- Elapsed: 2863ms
-- Environment: FBG

SELECT 
    o.settled_date_alk, o.acco_id, o.game_id, o.platform_id, o.state,
    o.expected_ggr AS old_exp_ggr, 
    n.expected_ggr_usd AS new_exp_ggr,
    o.expected_ggr - n.expected_ggr_usd AS diff,
    o.skill_based_rtp AS old_rtp,
    n.skill_based_rtp AS new_rtp,
    o.theoretical_rtp AS old_theo_rtp,
    n.theoretical_rtp AS new_theo_rtp,
    o.jackpot_contribution_rate AS old_jackpot,
    n.jackpot_contribution_rate AS new_jackpot
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg o
JOIN fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd n
    ON o.acco_id = n.acco_id AND o.game_id = n.game_id 
    AND o.platform_id = n.platform_id AND EQUAL_NULL(o.state, n.state)
    AND o.settled_date_alk = n.settled_date_alk
WHERE o.settled_date_alk = '2026-01-01'
  AND ABS(o.expected_ggr - n.expected_ggr_usd) > 0.01
ORDER BY ABS(o.expected_ggr - n.expected_ggr_usd) DESC
LIMIT 10
