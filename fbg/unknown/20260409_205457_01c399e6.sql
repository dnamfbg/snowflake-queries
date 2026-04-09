-- Query ID: 01c399e6-0212-67a8-24dd-0703192e3ba7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:54:57.414000+00:00
-- Elapsed: 12674ms
-- Environment: FBG

select * 
from FBG_ANALYTICS_ENGINEERING.APPLICATION.GEOLOCATION_PINGS_COMBINED
where account_id = 4645989
order by row_created_time asc
