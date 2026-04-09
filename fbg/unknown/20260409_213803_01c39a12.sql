-- Query ID: 01c39a12-0212-67a8-24dd-07031938e5bf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:38:03.827000+00:00
-- Elapsed: 1361ms
-- Environment: FBG

SELECT * FROM FDE_FBG_PII_INFO.FDE_FBG_PII_INFO.FANGRAPH_PII_V where fbg_account_creation_timestamp is null limit 10;
