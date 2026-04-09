-- Query ID: 01c39a01-0112-6806-0000-e307218b629e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:21:37.624000+00:00
-- Elapsed: 996ms
-- Environment: FES

select * from loyalty.loyalty_core.loyalty_analytics_ledger where fancash_balance < 0
