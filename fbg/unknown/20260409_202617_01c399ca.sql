-- Query ID: 01c399ca-0212-6b00-24dd-0703192880f7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:26:17.021000+00:00
-- Elapsed: 985ms
-- Environment: FBG

SELECT 
    'old' AS tbl, settled_date_alk, acco_id, game_id, platform_id, state,
    total_bet_count, total_stake, total_payout, ggr, ngr, 
    cash_bet_stake, cash_bet_payout, expected_ggr, expected_ngr,
    skill_based_rtp, record_last_updated
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk = '2026-01-21' AND acco_id = 4271879 AND game_id = '4379'
UNION ALL
SELECT 
    'new', settled_date_alk, acco_id, game_id, platform_id, state,
    total_bet_count, total_stake_usd, total_payout_usd, ggr_usd, ngr_usd,
    cash_bet_stake_usd, cash_bet_payout_usd, expected_ggr_usd, expected_ngr_usd,
    skill_based_rtp, record_last_updated
FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
WHERE settled_date_alk = '2026-01-21' AND acco_id = 4271879 AND game_id = '4379'
