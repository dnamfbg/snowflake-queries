-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4d27
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:19.692000+00:00
-- Elapsed: 1123ms
-- Environment: FBG

INSERT INTO FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_historical_100k(
select * from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_100k
)
