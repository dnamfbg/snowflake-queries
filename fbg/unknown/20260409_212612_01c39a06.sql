-- Query ID: 01c39a06-0212-6dbe-24dd-070319359f5f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:26:12.509000+00:00
-- Elapsed: 567ms
-- Environment: FBG

SELECT 
  CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END as period,
  ACQUISITION_CHANNEL,
  COUNT(*) as customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END), 1) as pct_of_total
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1, 2
HAVING COUNT(*) > 100
ORDER BY 1, 4 DESC
