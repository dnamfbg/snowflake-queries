-- Query ID: 01c39a05-0212-644a-24dd-070319356d97
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:25:12.106000+00:00
-- Elapsed: 448ms
-- Environment: FBG

with temp as (
select * from fbg_analytics.vip.vip_status_history
where calendar_date = '2026-03-31'
and vip_status_day = 'vip'
)

select
loyalty_tier,
count(a.*)
from fbg_analytics.product_and_customer.f1_attributes_audits a
inner join temp b
on a.acco_id = b.acco_id
where a.as_of_date = '2026-03-31'
group by all
