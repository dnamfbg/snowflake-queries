-- Query ID: 01c39a0e-0212-6e7d-24dd-07031938076b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:13.023000+00:00
-- Elapsed: 4241ms
-- Environment: FBG

SELECT 
  TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_cash_handle,
  ROUND(AVG(LTV_PRED_D15_TO_D90), 2) as avg_v2_pred_d15_d90,
  ROUND(AVG(LTV_PRED_D90), 2) as avg_v2_total_pred_d90,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90_handle,
  ROUND(AVG(LTV_PRED_D90) - AVG(D90CASH_HANDLE), 2) as v2_overpredict,
  ROUND((AVG(LTV_PRED_D90) - AVG(D90CASH_HANDLE)) / NULLIF(AVG(D90CASH_HANDLE), 0) * 100, 1) as v2_pct_over,
  ROUND(MEDIAN(LTV_PRED_D90), 2) as median_v2_pred,
  ROUND(MEDIAN(D90CASH_HANDLE), 2) as median_actual_d90
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
WHERE D90 <= CURRENT_DATE()
GROUP BY 1
ORDER BY 1
