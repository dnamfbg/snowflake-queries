-- Query ID: 01c399ca-0212-6b00-24dd-0703192880ef
-- Database: FBG_CORTEX
-- Schema: CORTEX_DEV
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:26:16.748000+00:00
-- Elapsed: 32010ms
-- Environment: FBG

select distinct transaction_currency 
from fbg_analytics_engineering.transactions.silver__transactions_mart
