-- Query ID: 01c39a4c-0212-6dbe-24dd-07031945f62b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:36:57.456000+00:00
-- Elapsed: 2220ms
-- Environment: FBG

select * from FBG_REPORTS.REGULATORY.unsettled_bets_report order by "Gaming Date" desc limit 10
