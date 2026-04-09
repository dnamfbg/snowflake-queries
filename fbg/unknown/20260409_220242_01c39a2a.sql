-- Query ID: 01c39a2a-0212-6dbe-24dd-0703193e8423
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:42.416000+00:00
-- Elapsed: 48009ms
-- Environment: FBG

select *
from fbg_source.osb_source.account_statements
where acco_id = 2022776
order by trans_date asc
