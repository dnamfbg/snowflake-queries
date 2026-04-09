-- Query ID: 01c399fe-0212-6cb9-24dd-070319344453
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:18:15.080000+00:00
-- Elapsed: 93ms
-- Environment: FBG

select min(sportsbook_ftu_date_alk)
from fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
limit 10;
