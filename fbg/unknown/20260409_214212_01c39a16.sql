-- Query ID: 01c39a16-0212-6b00-24dd-07031939cf77
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:42:12.865000+00:00
-- Elapsed: 727ms
-- Environment: FBG

SELECT * FROM fbg_analytics.product_and_customer.stg_affiliate_campaign WHERE LOWER(CAMPAIGN) LIKE '%testing caps%'
