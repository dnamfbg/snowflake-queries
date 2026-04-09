-- Query ID: 01c39a17-0212-6dbe-24dd-07031939eddf
-- Database: FBG_P13N
-- Schema: FBG_P13N
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:43:24.823000+00:00
-- Elapsed: 704ms
-- Environment: FBG

select
    region,
    region
from FBG_P13N.FBG_P13N.search_session_interactions
where (event_time >= ('2026-04-08 21:43:24')::timestamp AND event_time < ('2026-04-09 21:43:24')::timestamp) 
and length(search_keyword) >= 3
and true
group by 1
order by 1 asc
