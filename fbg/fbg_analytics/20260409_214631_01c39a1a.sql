-- Query ID: 01c39a1a-0212-6dbe-24dd-0703193a8f63
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:46:31.023000+00:00
-- Elapsed: 817ms
-- Environment: FBG

select acco_id,
acquisition_bonus_name,
acquisition_promotion_id_on_registration
from
fbg_analytics_engineering.customers.customer_mart
where
acco_id in (5717812)
