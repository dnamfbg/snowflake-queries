-- Query ID: 01c39a1f-0212-6e7d-24dd-0703193bd8f3
-- Database: FBG_ANALYTICS_ENGINEERING_DEV
-- Schema: TRADING
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:51:00.407000+00:00
-- Elapsed: 112ms
-- Environment: FBG

select * from table(result_scan('01c39a1e-0212-6dbe-24dd-0703193bac6f'))
