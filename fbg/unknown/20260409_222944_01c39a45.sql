-- Query ID: 01c39a45-0212-67a8-24dd-07031944824b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:29:44.699000+00:00
-- Elapsed: 1811ms
-- Environment: FBG

SELECT distinct acquisition_retention, * FROM PMG_TO_FBG."fbg_custom"."analytics_cross_channel" where account_id = 'genius';
