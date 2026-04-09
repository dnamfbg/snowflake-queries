-- Query ID: 01c39a20-0212-6dbe-24dd-0703193c328f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:52:05.725000+00:00
-- Elapsed: 2920ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS_ENGINEERING_DEV.FINANCE.FINANCE_TRANSACTIONS_MART_TEST  order by trans_date_alk desc limit 1000 -- where transaction_type like '%ADJUSTMENT%'
;
