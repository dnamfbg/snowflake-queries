-- Query ID: 01c39a2a-0212-6cb9-24dd-0703193e7783
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:20.837000+00:00
-- Elapsed: 2009ms
-- Environment: FBG

CREATE OR REPLACE TEMP TABLE final as(
select a.* from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_100k as a
left join FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS as b
on a.acco_id = b.acco_id
where (b.high_level_segment <> 'Super VIP' or b.high_level_segment is null)
)
