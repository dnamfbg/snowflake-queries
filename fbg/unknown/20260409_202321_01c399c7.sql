-- Query ID: 01c399c7-0212-67a8-24dd-07031927d77f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:23:21.216000+00:00
-- Elapsed: 7475ms
-- Environment: FBG

SELECT settled_date_alk, acco_id, game_id, platform_id, state, is_test_account, total_bet_count
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk IN ('2026-04-05', '2026-04-06')
EXCEPT
SELECT settled_date_alk, acco_id, game_id, platform_id, state, is_test_account, total_bet_count
FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
WHERE settled_date_alk IN ('2026-04-05', '2026-04-06')
