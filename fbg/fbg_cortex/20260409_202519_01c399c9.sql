-- Query ID: 01c399c9-0212-6e7d-24dd-07031928279b
-- Database: FBG_CORTEX
-- Schema: CORTEX_DEV
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:25:19.102000+00:00
-- Elapsed: 391ms
-- Environment: FBG

select *
from fbg_analytics_engineering.staging.bronze__osb_source_account_statements
where currency is null;
