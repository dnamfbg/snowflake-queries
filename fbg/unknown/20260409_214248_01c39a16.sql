-- Query ID: 01c39a16-0212-67a8-24dd-0703193a1983
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:42:48.539000+00:00
-- Elapsed: 101ms
-- Environment: FBG

select * from fbg_analytics.product_and_customer.stg_affiliate_campaign where campaign is null;
