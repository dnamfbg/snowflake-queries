-- Query ID: 01c39a2f-0212-6e7d-24dd-0703193f9713
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:07:53.819000+00:00
-- Elapsed: 1326ms
-- Environment: FBG

select count(*) from fbg_source.osb_source.account_bonuses where is_deleted = TRUE
