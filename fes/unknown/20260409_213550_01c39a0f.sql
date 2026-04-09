-- Query ID: 01c39a0f-0112-6544-0000-e307218ba6c2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:35:50.098000+00:00
-- Elapsed: 9776ms
-- Environment: FES

select * from loyalty.loyalty_core.loyalty_earn_burn_mapper where creation_time >= DATEADD(DAY, -60, CURRENT_DATE) AND loyalty_account_id = 'dda324a0-463c-11ea-80c0-fdc607655f54'
