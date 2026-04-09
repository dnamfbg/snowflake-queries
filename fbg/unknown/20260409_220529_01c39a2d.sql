-- Query ID: 01c39a2d-0212-6dbe-24dd-0703193f0aeb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T22:05:29.162000+00:00
-- Elapsed: 2288ms
-- Run Count: 2
-- Environment: FBG

select * from fbg_source.osb_source.account_bonuses where acco_id = 354 and bonus_campaign_id = 15648
