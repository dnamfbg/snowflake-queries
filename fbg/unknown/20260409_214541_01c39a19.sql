-- Query ID: 01c39a19-0212-6dbe-24dd-0703193a8c43
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:45:41.726000+00:00
-- Elapsed: 729ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.INTERNAL.REGULATORY_TRANSACTIONS_MART_TEST where transaction_type like '%ADJUSTMENT%'

;
