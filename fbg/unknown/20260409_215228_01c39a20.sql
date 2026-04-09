-- Query ID: 01c39a20-0212-6cb9-24dd-0703193bebdf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:52:28.039000+00:00
-- Elapsed: 73ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.FINANCE.FINANCE_TRANSACTIONS_MART_TEST where transaction_type like '%ADJUSTMENT%'
;
