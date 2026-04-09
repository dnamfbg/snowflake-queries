-- Query ID: 01c399f1-0212-6dbe-24dd-0703193100d3
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:05:06.201000+00:00
-- Elapsed: 2506ms
-- Environment: FBG

SELECT DISTINCT CHANNEL FROM FBG_SOURCE.OSB_SOURCE.BETS LIMIT 20
