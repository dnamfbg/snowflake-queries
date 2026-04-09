-- Query ID: 01c399f2-0212-6e7d-24dd-07031930fc6f
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:06:21.701000+00:00
-- Elapsed: 2050ms
-- Environment: FBG

SELECT * FROM FBG_GOVERNANCE.GOVERNANCE.BET_BY_PAGE WHERE BET_TYPE = 'Parlay' AND SOURCE IN ('home', 'discover', 'live_page_v2') LIMIT 10
