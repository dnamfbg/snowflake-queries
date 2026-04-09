-- Query ID: 01c39a1e-0212-6e7d-24dd-0703193bd79f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:50:53.360000+00:00
-- Elapsed: 4593ms
-- Environment: FBG

select acco_id,
ref1
from 
fbg_source.osb_source.account_bonuses  a
join fbg_source.osb_source.accounts b
on b.id = a.acco_id
where
bonus_campaign_id = 1101362
and state = 'APPLIED'
