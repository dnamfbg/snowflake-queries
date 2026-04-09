-- Query ID: 01c39a34-0212-6cb9-24dd-07031940bf4f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:12:34.410000+00:00
-- Elapsed: 9105ms
-- Environment: FBG

select *
from fbg_source.osb_source.withdrawals
where account_id = 2022776
order by initiated_at asc
