-- Query ID: 01c39a33-0212-6e7d-24dd-070319408caf
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:11:31.972000+00:00
-- Elapsed: 6807ms
-- Environment: FBG

With table1 as (
select
NODE_ID,
NAME,
ID,
SETTLED,
CASE WHEN ATTRIBUTES ILIKE '%manual%' THEN 1 ELSE 0 END AS MANUAL_MARKET
from FBG_SOURCE.OSB_SOURCE.MARKETS
where ATTRIBUTES ILIKE '%manual%'
and ATTRIBUTES NOT like '%source=BETRADAR%'
and ATTRIBUTES NOT like '%source=ODDSFACTORY%'
and ATTRIBUTES NOT like '%source=BETGENIUS%'
and SETTLED = 0
--and NODE_ID = 2313345
)
,
table2 as (
select
EVENT_SPORT_NAME,
EVENT_NODE_ID,
EVENT_NAME,
EVENT_TIME_UTC,
EVENT_TIME_EST
from fbg_analytics_engineering.trading.sporting_events
),
table3 as(
SELECT
tb2.EVENT_SPORT_NAME,
tb2.EVENT_NAME,
tb1.NODE_ID,
tb1.NAME,
tb1.ID,
tb2.EVENT_TIME_UTC,
tb2.EVENT_TIME_EST,
tb1.SETTLED,
tb1.MANUAL_MARKET
from table1 tb1
left join table2 tb2
on tb1.NODE_ID = tb2.EVENT_NODE_ID
where tb2.EVENT_TIME_UTC > DATEADD(day, -1, CURRENT_TIMESTAMP)
order by tb2.EVENT_TIME_UTC asc, tb1.ID asc
)
SELECT
tb3.EVENT_SPORT_NAME,
tb3.EVENT_NAME,
tb3.NODE_ID,
tb3.NAME,
tb3.ID,
MANUAL_MARKET,
i.name as leg_selection,
i.id as selection_id,
tb3.EVENT_TIME_est,
from table3 tb3
LEFT join fbg_source.osb_source.instruments i
on tb3.ID = i.mark_id
group by all
order by tb3.EVENT_TIME_est asc, tb3.ID asc;
