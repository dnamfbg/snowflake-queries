-- Query ID: 01c39a28-0212-67a8-24dd-0703193dd643
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:00:31.141000+00:00
-- Elapsed: 2910ms
-- Environment: FBG

select * from fbg_analytics.product_and_customer.stg_affiliate_campaign
where campaign in ('testing');
