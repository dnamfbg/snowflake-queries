-- Query ID: 01c39a0e-0212-6cb9-24dd-070319382b3f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:34:54.535000+00:00
-- Elapsed: 3831ms
-- Environment: FBG

select account_id, a.username as "Amelco ID",
case when a.vip = 1 then 'YES' else 'NO' end as "VIP Customer",
vip_host
from fbg_source.loyalty_source.sweepstakes_entries e
join fbg_source.osb_source.accounts a on e.account_id = a.id
join fbg_analytics_engineering.customers.customer_mart u
on u.acco_id = a.id
where
result = 'WIN' and
bonus_campaign_id = 1105916;
