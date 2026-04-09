-- Query ID: 01c39a53-0212-6dbe-24dd-070319472e8b
-- Database: FBG_P13N
-- Schema: FBG_P13N
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:43:26.853000+00:00
-- Elapsed: 1066ms
-- Environment: FBG

select
    region,
    region
from FBG_P13N.FBG_P13N.search_session_interactions
where (event_time >= ('2026-04-08 22:43:26')::timestamp AND event_time < ('2026-04-09 22:43:26')::timestamp) 
and length(search_keyword) >= 3
and true
group by 1
order by 1 asc
