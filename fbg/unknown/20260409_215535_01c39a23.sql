-- Query ID: 01c39a23-0212-6e7d-24dd-0703193cc46f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:55:35.130000+00:00
-- Elapsed: 41681ms
-- Environment: FBG

SELECT * FROM FBG_SOURCE.FANX_MONGODB.FANCASH
WHERE ATS_ACCOUNT_ID = '1811845'
  AND FANCASH_AMOUNT = 25;
