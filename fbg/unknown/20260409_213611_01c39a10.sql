-- Query ID: 01c39a10-0212-6cb9-24dd-07031938940f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:36:11.870000+00:00
-- Elapsed: 601ms
-- Environment: FBG

select top 100 * from fbg_source.crypto.stacked_ledger where posting_business_date='2026-02-10'
