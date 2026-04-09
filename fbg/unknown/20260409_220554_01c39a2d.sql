-- Query ID: 01c39a2d-0212-67a9-24dd-0703193f432b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:05:54.769000+00:00
-- Elapsed: 1308ms
-- Environment: FBG

select sum(coalesce(osb_cash_handle,0) + coalesce(oc_cash_handle, 0) ) as handle
from fbg_analytics.product_and_customer.customer_variable_profit
where date_trunc('quarter', date) = '2026-01-01'
and acco_id = '1515339'
