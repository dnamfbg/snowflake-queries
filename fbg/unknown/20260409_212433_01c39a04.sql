-- Query ID: 01c39a04-0212-67a9-24dd-07031935a2c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:24:33.408000+00:00
-- Elapsed: 800ms
-- Environment: FBG

SELECT 
  MIN(D14) as min_d14, MAX(D14) as max_d14,
  COUNT(*) as total_rows,
  COUNT(DISTINCT ACCOUNT_ID) as unique_accounts,
  MIN(D90) as min_d90, MAX(D90) as max_d90
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
