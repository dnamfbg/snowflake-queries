-- Query ID: 01c39a06-0212-644a-24dd-07031935e463
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:26:11.479000+00:00
-- Elapsed: 246ms
-- Environment: FBG

SELECT 
  CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END as period,
  FIRST_BET_STATE,
  COUNT(*) as customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END), 1) as pct_of_total,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1, 2
HAVING COUNT(*) > 500
ORDER BY 1, 3 DESC
