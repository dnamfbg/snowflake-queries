-- Query ID: 01c39a10-0212-67a9-24dd-070319385cbb
-- Database: FBG_P13N
-- Schema: FBG_P13N
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:36:42.396000+00:00
-- Elapsed: 1389ms
-- Environment: FBG

select
    search_keyword,
    search_keyword
from FBG_P13N.FBG_P13N.search_session_interactions
where (event_time >= ('2026-04-08 21:36:42')::timestamp AND event_time < ('2026-04-09 21:36:42')::timestamp) 
and length(search_keyword) >= 3
and true
group by 1
order by count(*) desc
