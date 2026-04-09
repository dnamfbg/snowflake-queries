-- Query ID: 01c39a06-0212-67a9-24dd-0703193602ff
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:26:39.171000+00:00
-- Elapsed: 190ms
-- Environment: FBG

SELECT 
  CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END as period,
  CURRENT_VALUE_BAND,
  COUNT(*) as customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END), 1) as pct_of_total
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1, 2
ORDER BY 1, 3 DESC
