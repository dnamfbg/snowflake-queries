-- Query ID: 01c39a0e-0212-6cb9-24dd-070319382b9f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:56.884000+00:00
-- Elapsed: 648ms
-- Environment: FBG

SELECT 
  TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  ACQUISITION_CHANNEL,
  COUNT(*) as customers,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM')), 1) as pct_of_cohort,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
WHERE D90 <= CURRENT_DATE()
GROUP BY 1, 2
HAVING COUNT(*) > 200
ORDER BY 1, 3 DESC
