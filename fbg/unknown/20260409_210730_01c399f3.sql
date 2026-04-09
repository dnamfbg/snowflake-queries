-- Query ID: 01c399f3-0212-6cb9-24dd-07031931560f
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:07:30+00:00
-- Elapsed: 245ms
-- Environment: FBG

SELECT MIN(WAGER_PLACED_TIME_ALK) AS min_date, MAX(WAGER_PLACED_TIME_ALK) AS max_date, COUNT(*) AS total_rows FROM FBG_ANALYTICS_DEV.KELHAM_BENNETT.MIXED_BETS_PLACED
