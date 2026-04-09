-- Query ID: 01c39a3d-0212-6cb9-24dd-070319428d03
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:21:28.065000+00:00
-- Elapsed: 775ms
-- Environment: FBG

INSERT INTO FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_historical_10k(
select * from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_10k
)
