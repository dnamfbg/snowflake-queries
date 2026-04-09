-- Query ID: 01c399f3-0212-6b00-24dd-070319313dc7
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:07:59.126000+00:00
-- Elapsed: 1503ms
-- Environment: FBG

SELECT BET_CT, COUNT(*) AS row_count FROM FBG_GOVERNANCE.GOVERNANCE.BET_BY_PAGE WHERE BET_TYPE IN ('MULTIPLE', 'SGP_STACK') AND SOURCE IN ('home', 'discover', 'live_page_v2') GROUP BY BET_CT ORDER BY BET_CT LIMIT 20
