-- Query ID: 01c39a2e-0212-6e7d-24dd-0703193f1daf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:06:44.427000+00:00
-- Elapsed: 43911ms
-- Environment: FBG

select * from fbg_source.osb_source.account_bonuses where is_deleted = TRUE
