-- Query ID: 01c399d8-0212-6b00-24dd-0703192b645b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:40:04.422000+00:00
-- Elapsed: 4900ms
-- Environment: FBG

select *, convert_timezone('UTC','America/New_York',TO_TIMESTAMP(split_part(regexp_substr(a.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_timestamp_est
from 
fbg_source.osb_source.account_bonuses a
join fbg_analytics.product_and_customer.bonus_categories b
on a.bonus_campaign_id = b.bonus_campaign_id
where
acco_id = 3314118
and a.bonus_campaign_id = 1101364
