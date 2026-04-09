-- Query ID: 01c39a65-0212-6dbe-24dd-0703194b0ccb
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T23:01:24.644000+00:00
-- Elapsed: 1187ms
-- Run Count: 3
-- Environment: FBG

SELECT ROW_COUNT FROM "FBG_SOURCE".INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Custom SQL Query' AND TABLE_SCHEMA = 'OSB_SOURCE'
