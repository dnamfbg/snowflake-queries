-- Query ID: 01c39a4c-0212-6e7d-24dd-070319457d6b
-- Database: FBG_P13N
-- Schema: FBG_P13N
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:36:45.384000+00:00
-- Elapsed: 1438ms
-- Environment: FBG

select
    search_keyword,
    search_keyword
from FBG_P13N.FBG_P13N.search_session_interactions
where (event_time >= ('2026-04-08 22:36:45')::timestamp AND event_time < ('2026-04-09 22:36:45')::timestamp) 
and length(search_keyword) >= 3
and true
group by 1
order by count(*) desc
