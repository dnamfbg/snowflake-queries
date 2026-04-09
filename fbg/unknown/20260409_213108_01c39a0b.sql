-- Query ID: 01c39a0b-0212-6b00-24dd-07031936f8cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:31:08.744000+00:00
-- Elapsed: 14277ms
-- Environment: FBG

select *, convert_timezone('UTC','America/New_York',TO_TIMESTAMP(split_part(regexp_substr(a.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_timestamp_est
from
fbg_source.osb_source.account_bonuses a
join fbg_analytics.product_and_customer.bonus_categories b
on a.bonus_campaign_id = b.bonus_campaign_id
where
acco_id = (718751)
and a.bonus_campaign_id = 184509
