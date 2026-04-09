-- Query ID: 01c39a16-0212-6cb9-24dd-0703193a356b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:42:56.057000+00:00
-- Elapsed: 726ms
-- Environment: FBG

select * from fbg_source.salesforce.o_case_history 
where field = 'Owner'
and newvalue= 'Jose Migoya'
limit 10
