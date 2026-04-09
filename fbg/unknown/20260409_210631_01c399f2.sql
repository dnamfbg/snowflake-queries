-- Query ID: 01c399f2-0212-6b00-24dd-0703193130fb
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:06:31.080000+00:00
-- Elapsed: 462ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.BETS_BY_PAGE WHERE BET_TYPE IN ('MULTIPLE', 'SGP_STACK') AND SOURCE IN ('home', 'discover', 'live_page_v2') LIMIT 10
