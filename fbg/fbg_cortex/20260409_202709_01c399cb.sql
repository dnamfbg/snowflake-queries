-- Query ID: 01c399cb-0212-6e7d-24dd-07031928c36b
-- Database: FBG_CORTEX
-- Schema: CORTEX_DEV
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:27:09.587000+00:00
-- Elapsed: 34513ms
-- Environment: FBG

select distinct transaction_currency 
from fbg_analytics_engineering.transactions.silver__transactions_mart
;
