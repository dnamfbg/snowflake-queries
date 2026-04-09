-- Query ID: 01c39a05-0212-6b00-24dd-07031935d35f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:25:56.273000+00:00
-- Elapsed: 333ms
-- Environment: FBG

SELECT 
  DATE_TRUNC('month', D14) as cohort_month,
  COUNT(*) as customers,
  ROUND(AVG(FOOTBALL_CASH_BET_AMOUNT), 2) as avg_football,
  ROUND(AVG(BASKETBALL_CASH_BET_AMOUNT), 2) as avg_basketball,
  ROUND(AVG(BASEBALL_CASH_BET_AMOUNT), 2) as avg_baseball,
  ROUND(AVG(HOCKY_CASH_BET_AMOUNT), 2) as avg_hockey,
  ROUND(AVG(SOCCER_CASH_BET_AMOUNT), 2) as avg_soccer,
  ROUND(AVG(TENNIS_CASH_BET_AMOUNT), 2) as avg_tennis,
  ROUND(AVG(GOLF_CASH_BET_AMOUNT), 2) as avg_golf,
  ROUND(AVG(OTHER_CASH_BET_AMOUNT), 2) as avg_other
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1
ORDER BY 1
