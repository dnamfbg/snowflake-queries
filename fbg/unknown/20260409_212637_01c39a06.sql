-- Query ID: 01c39a06-0212-67a9-24dd-0703193602d3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:26:37.755000+00:00
-- Elapsed: 1164ms
-- Environment: FBG

SELECT 
  DATE_TRUNC('month', o.D14) as cohort_month,
  COUNT(*) as matched_customers,
  ROUND(AVG(o.LTV_PRED), 2) as old_avg_pred,
  ROUND(AVG(n.LTV_PRED_D15_TO_D90), 2) as new_avg_pred,
  ROUND(AVG(o.D90CASH_HANDLE), 2) as avg_actual_d90,
  ROUND(AVG(o.D90_LTV_PRED) - AVG(o.D90CASH_HANDLE), 2) as old_overpredict,
  ROUND(AVG(n.LTV_PRED_D90) - AVG(n.D90CASH_HANDLE), 2) as new_overpredict,
  ROUND((AVG(o.D90_LTV_PRED) - AVG(o.D90CASH_HANDLE)) / NULLIF(AVG(o.D90CASH_HANDLE), 0) * 100, 1) as old_pct_over,
  ROUND((AVG(n.LTV_PRED_D90) - AVG(n.D90CASH_HANDLE)) / NULLIF(AVG(n.D90CASH_HANDLE), 0) * 100, 1) as new_pct_over
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS o
JOIN fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2 n
  ON o.ACCOUNT_ID = n.ACCOUNT_ID
WHERE o.D90 <= CURRENT_DATE()
GROUP BY 1
ORDER BY 1
