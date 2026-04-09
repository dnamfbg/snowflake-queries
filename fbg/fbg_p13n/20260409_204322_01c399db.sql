-- Query ID: 01c399db-0212-67a9-24dd-0703192c15ab
-- Database: FBG_P13N
-- Schema: FBG_P13N
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T20:43:22.384000+00:00
-- Elapsed: 1480ms
-- Environment: FBG

select
    region,
    region
from FBG_P13N.FBG_P13N.search_session_interactions
where (event_time >= ('2026-04-08 20:43:22')::timestamp AND event_time < ('2026-04-09 20:43:22')::timestamp) 
and length(search_keyword) >= 3
and true
group by 1
order by 1 asc
