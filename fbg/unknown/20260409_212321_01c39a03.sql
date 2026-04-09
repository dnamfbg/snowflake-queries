-- Query ID: 01c39a03-0212-6b00-24dd-07031935517b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:23:21.532000+00:00
-- Elapsed: 30368ms
-- Environment: FBG

select * from fbg_analytics.vip.pnl_overall where "Loyalty Tier" is null
