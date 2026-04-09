-- Query ID: 01c39a49-0212-67a8-24dd-0703194543a7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:33:39.023000+00:00
-- Elapsed: 1051ms
-- Environment: FBG

SELECT a.acco_id,
a.high_level_segment_new,
FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SPORTSBOOK_CRM_ATTRIBUTES a
WHERE a.acco_id = '4866275'
