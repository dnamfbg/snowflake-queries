-- Query ID: 01c39a2c-0212-6dbe-24dd-0703193f0517
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:04:42.662000+00:00
-- Elapsed: 6774ms
-- Environment: FBG

select * from fbg_source.osb_source.account_bonuses_history where acco_id = 354 and bonus_campaign_id = 15648
