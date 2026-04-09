-- Query ID: 01c39a1e-0212-6cb9-24dd-0703193be14f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:50:26.684000+00:00
-- Elapsed: 658ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.REGULATORY.REGULATORY_RETAIL_TRANSACTIONS_MART where transaction_account_id = '229825' --where transaction_type like '%ADJUSTMENT%'
;
