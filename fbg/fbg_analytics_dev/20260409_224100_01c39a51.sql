-- Query ID: 01c39a51-0212-67a9-24dd-07031946bd17
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:41:00.716000+00:00
-- Elapsed: 884ms
-- Environment: FBG

INSERT INTO FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_deposit_alert_historical_100k(
select * from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_deposit_alert_100k
)
