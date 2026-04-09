-- Query ID: 01c39a16-0212-6cb9-24dd-0703193a337b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:42:29.706000+00:00
-- Elapsed: 743ms
-- Environment: FBG

DELETE FROM fbg_analytics.product_and_customer.stg_affiliate_campaign
WHERE CAMPAIGN = 'testing caps';
