-- Query ID: 01c39a4b-0212-6cb9-24dd-070319456847
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:35:23.891000+00:00
-- Elapsed: 1591ms
-- Environment: FBG

select * from FBG_REPORTS.REGULATORY.stg_traveling_account_balances order by gaming_date desc limit 10
