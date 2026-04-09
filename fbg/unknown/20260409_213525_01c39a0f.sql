-- Query ID: 01c39a0f-0212-6dbe-24dd-07031938641b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:35:25.087000+00:00
-- Elapsed: 1343ms
-- Environment: FBG

SELECT 
  TO_CHAR(v2.SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  COUNT(*) as customers,
  ROUND(AVG(v2.CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(v1.D90_LTV_PRED), 2) as avg_v1_pred_d90,
  ROUND(AVG(v2.LTV_PRED_D90), 2) as avg_v2_pred_d90,
  ROUND(AVG(v2.D90CASH_HANDLE), 2) as avg_actual_d90,
  ROUND(AVG(v1.D90_LTV_PRED) - AVG(v2.D90CASH_HANDLE), 2) as v1_error,
  ROUND(AVG(v2.LTV_PRED_D90) - AVG(v2.D90CASH_HANDLE), 2) as v2_error,
  ROUND((AVG(v1.D90_LTV_PRED) - AVG(v2.D90CASH_HANDLE)) / NULLIF(AVG(v2.D90CASH_HANDLE), 0) * 100, 1) as v1_pct_error,
  ROUND((AVG(v2.LTV_PRED_D90) - AVG(v2.D90CASH_HANDLE)) / NULLIF(AVG(v2.D90CASH_HANDLE), 0) * 100, 1) as v2_pct_error
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2 v2
LEFT JOIN fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS v1
  ON v1.ACCOUNT_ID = v2.ACCOUNT_ID
WHERE v2.D90 <= CURRENT_DATE()
GROUP BY 1
ORDER BY 1
