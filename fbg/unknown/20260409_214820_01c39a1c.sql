-- Query ID: 01c39a1c-0212-6cb9-24dd-0703193b63a3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:48:20.150000+00:00
-- Elapsed: 84300ms
-- Environment: FBG

SELECT * FROM FBG_SOURCE.FANX_MONGODB.FANCASH
WHERE ATS_ACCOUNT_ID = '5053729'
  AND FANCASH_AMOUNT = 25;
