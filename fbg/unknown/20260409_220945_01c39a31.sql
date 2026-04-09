-- Query ID: 01c39a31-0212-6e7d-24dd-070319401aa7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH_PROD
-- Executed: 2026-04-09T22:09:45.595000+00:00
-- Elapsed: 1355ms
-- Environment: FBG

select case_type, count (*)
from fbg_analytics.operations.cs_cases
where date (case_created_est) >= '2026-01-01'
and case_type like 'Casino%'
group by 1
order by 1
