-- Query ID: 01c39a06-0212-644a-24dd-07031935e553
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:26:18.103000+00:00
-- Elapsed: 3161ms
-- Environment: FBG

select * from fbg_analytics.vip.pnl_overall where "Loyalty Tier" is null
and "Date" >= '2025-12-01'
and "Cash Handle" > 0
