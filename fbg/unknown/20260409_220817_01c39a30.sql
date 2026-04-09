-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe207
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:08:17.313000+00:00
-- Elapsed: 3298ms
-- Environment: FBG

select count(*) from fbg_source.osb_source.account_bonuses where is_deleted = FALSE
