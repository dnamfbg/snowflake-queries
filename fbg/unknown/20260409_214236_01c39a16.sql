-- Query ID: 01c39a16-0212-644a-24dd-0703193a6027
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T21:42:36.177000+00:00
-- Elapsed: 201ms
-- Run Count: 2
-- Environment: FBG

select * from fbg_analytics.product_and_customer.stg_affiliate_campaign
where campaign in ('testing caps');
