-- Query ID: 01c399f2-0212-6cb9-24dd-07031930c003
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:06:40.989000+00:00
-- Elapsed: 721ms
-- Environment: FBG

SELECT * FROM FBG_GOVERNANCE.GOVERNANCE.BET_BY_PAGE WHERE BET_TYPE IN ('MULTIPLE', 'SGP_STACK') AND SOURCE IN ('home', 'discover', 'live_page_v2') LIMIT 10
