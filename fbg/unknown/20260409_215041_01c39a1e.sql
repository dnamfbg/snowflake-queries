-- Query ID: 01c39a1e-0212-67a9-24dd-0703193b9a37
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:50:41.042000+00:00
-- Elapsed: 97ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.REGULATORY.REGULATORY_RETAIL_TRANSACTIONS_MART where transaction_type like '%ADJUSTMENT%'
;
