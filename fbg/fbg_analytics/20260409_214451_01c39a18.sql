-- Query ID: 01c39a18-0212-67a8-24dd-0703193a95b3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:44:51.175000+00:00
-- Elapsed: 14586ms
-- Environment: FBG

SELECT
*
FROM
fbg_source.osb_source.account_bonuses a
join fbg_analytics_dev.will_mack.bonus_categories b
on a.bonus_campaign_id = b.bonus_campaign_id
where
acco_id = 5717812
order by date(created) desc
;
