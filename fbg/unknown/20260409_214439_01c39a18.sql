-- Query ID: 01c39a18-0212-6e7d-24dd-0703193aa1e3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:44:39.839000+00:00
-- Elapsed: 704ms
-- Environment: FBG

SELECT * FROM FBG_SOURCE_DEV.OSB_SOURCE.ACCOUNT_STATEMENTS where trans like '%ADJUSTMENT%'

;
