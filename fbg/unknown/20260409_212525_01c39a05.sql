-- Query ID: 01c39a05-0212-644a-24dd-070319356ecf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:25:25.253000+00:00
-- Elapsed: 278ms
-- Environment: FBG

SELECT 
  CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END as period,
  ACQUISITION_CHANNEL,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_cash_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
WHERE D90 <= CURRENT_DATE()
GROUP BY 1, 2
ORDER BY 1, 3 DESC
