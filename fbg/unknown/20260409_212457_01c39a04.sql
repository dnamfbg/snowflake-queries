-- Query ID: 01c39a04-0212-6cb9-24dd-070319354d6b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:24:57.424000+00:00
-- Elapsed: 393ms
-- Environment: FBG

SELECT 
  DATE_TRUNC('month', D14) as cohort_month,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_cash_handle,
  ROUND(AVG(LTV_PRED), 2) as avg_pred_d15_to_d90,
  ROUND(AVG(D90_LTV_PRED), 2) as avg_total_pred_d90,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90_handle,
  ROUND(AVG(D90_LTV_PRED) - AVG(D90CASH_HANDLE), 2) as avg_overpredict,
  ROUND((AVG(D90_LTV_PRED) - AVG(D90CASH_HANDLE)) / NULLIF(AVG(D90CASH_HANDLE), 0) * 100, 1) as pct_overpredict
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
WHERE D90 <= CURRENT_DATE()
GROUP BY 1
ORDER BY 1
