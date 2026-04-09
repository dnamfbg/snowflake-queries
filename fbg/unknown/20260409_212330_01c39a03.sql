-- Query ID: 01c39a03-0212-6dbe-24dd-070319351d27
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:23:30.981000+00:00
-- Elapsed: 5778ms
-- Environment: FBG

SELECT *
FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS
WHERE ACCO_ID = 6224940
LIMIT 100
