-- Query ID: 01c39a28-0212-6cb9-24dd-0703193e1613
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:00:59.904000+00:00
-- Elapsed: 116ms
-- Environment: FBG

select * from fbg_analytics.product_and_customer.stg_affiliate_campaign
where campaign in ('testing')
and affiliate = 'moonshot'
;
