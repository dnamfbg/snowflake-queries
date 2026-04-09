-- Query ID: 01c399c4-0212-6b00-24dd-070319275633
-- Database: FBG_CORTEX
-- Schema: CORTEX_DEV
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:20:57.033000+00:00
-- Elapsed: 192ms
-- Environment: FBG

select max(settled_date_alk)
from fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
limit 5;
