-- Query ID: 01c39a04-0212-6cb9-24dd-070319354b53
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:24:45.873000+00:00
-- Elapsed: 1508ms
-- Environment: FBG

with temp as (
select * from fbg_analytics.vip.vip_status_history
where calendar_date = '2026-03-31'
)

select
loyalty_tier,
count(a.*)
from fbg_analytics.product_and_customer.f1_attributes_audits a
inner join temp b
on a.acco_id = b.acco_id
where a.as_of_date = '2026-03-31'
group by all
