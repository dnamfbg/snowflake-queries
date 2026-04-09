-- Query ID: 01c39a4f-0212-6cb9-24dd-070319466de7
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T22:39:38.446000+00:00
-- Elapsed: 5217ms
-- Environment: FBG

SELECT 
a.acco_id,
a.balance
from fbg_source.osb_source.account_balances a 
left join fbg_source.osb_source.accounts b on a.acco_id = b.id
where 1=1
and fund_type_id = 1
and test = 0
and a.balance < 0
