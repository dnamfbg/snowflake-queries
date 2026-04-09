-- Query ID: 01c39a1a-0112-6bf9-0000-e307218be4f6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:46:05.324000+00:00
-- Elapsed: 3332ms
-- Environment: FES

select * from loyalty.loyalty_core.loyalty_analytics_ledger where creation_time >= DATEADD(DAY, -60, CURRENT_DATE) AND loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
