-- Query ID: 01c39a10-0112-65b6-0000-e307218b5c6a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:36:04.691000+00:00
-- Elapsed: 212ms
-- Environment: FES

select count(distinct private_fan_id) from fes_users.sandbox.fanapp_cohort_labels;
