-- Query ID: 01c39a1b-0212-67a8-24dd-0703193b24ef
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:47:32.407000+00:00
-- Elapsed: 212ms
-- Environment: FBG

select * from FBG_SOURCE_DEV.OSB_SOURCE.ACCOUNT_STATEMENTS where trans like '%ADJUSTMENT%'

;
