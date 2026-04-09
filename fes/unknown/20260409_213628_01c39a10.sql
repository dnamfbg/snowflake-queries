-- Query ID: 01c39a10-0112-6b51-0000-e307218b7baa
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Last Executed: 2026-04-09T21:36:28.934000+00:00
-- Elapsed: 163ms
-- Run Count: 2
-- Environment: FES

select * from loyalty.loyalty_core.loyalty_analytics_ledger where creation_time >= DATEADD(DAY, -60, CURRENT_DATE) AND loyalty_account_id = 'dda324a0-463c-11ea-80c0-fdc607655f54'
