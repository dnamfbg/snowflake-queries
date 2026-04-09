-- Query ID: 01c39a35-0212-644a-24dd-0703194132af
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:13:29.557000+00:00
-- Elapsed: 1700ms
-- Environment: FBG

SELECT MAX(DATEADD('hour', -24, "Gaming Date"::TIMESTAMP_NTZ(9))) FROM fbg_reports.regulatory.sportsbook_pasr
