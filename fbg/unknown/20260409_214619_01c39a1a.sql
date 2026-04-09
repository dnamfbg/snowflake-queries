-- Query ID: 01c39a1a-0212-6dbe-24dd-0703193a8ebf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:46:19.848000+00:00
-- Elapsed: 180ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.INTERNAL.REGULATORY_TRANSACTIONS_MART_TEST where transaction_account_id = '229825' --where transaction_type like '%ADJUSTMENT%'

;
