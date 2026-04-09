-- Query ID: 01c39a09-0212-67a8-24dd-07031936d1e3
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:29:41.112000+00:00
-- Elapsed: 365ms
-- Environment: FBG

select * from table(result_scan('01c399fa-0212-644a-24dd-07031933610f'))
