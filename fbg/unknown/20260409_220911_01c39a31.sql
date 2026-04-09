-- Query ID: 01c39a31-0212-644a-24dd-0703193ffcd3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:09:11.884000+00:00
-- Elapsed: 29628ms
-- Environment: FBG

select * from fbg_source.osb_source.account_bonuses where is_deleted = TRUE  -- 619244016
