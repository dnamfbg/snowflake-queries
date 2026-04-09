-- Query ID: 01c39a1b-0212-644a-24dd-0703193afb4f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:47:18.177000+00:00
-- Elapsed: 11633ms
-- Environment: FBG

SELECT
*
FROM
fbg_source.osb_source.account_bonuses a
join fbg_analytics_dev.will_mack.bonus_categories b
on a.bonus_campaign_id = b.bonus_campaign_id
where
acco_id = 3314118
order by date(created) desc
;
