-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe313
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:08:23.001000+00:00
-- Elapsed: 89ms
-- Environment: FBG

select * from table(result_scan('01c39a2f-0212-6dbe-24dd-0703193f6fd3'))
