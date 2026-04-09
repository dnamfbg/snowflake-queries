-- Query ID: 01c39a45-0212-6e7d-24dd-070319444fcf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:29:40.751000+00:00
-- Elapsed: 417ms
-- Environment: FBG

SELECT distinct acquisition_retention FROM PMG_TO_FBG."fbg_custom"."analytics_cross_channel" where account_id = 'genius';
