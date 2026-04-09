-- Query ID: 01c39a16-0212-644a-24dd-07031939deab
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:42:23.179000+00:00
-- Elapsed: 16632ms
-- Environment: FBG

select * from fbg_source.salesforce.o_case_history 
where field = 'Owner'
