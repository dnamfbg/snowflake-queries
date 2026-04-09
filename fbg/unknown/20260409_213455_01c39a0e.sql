-- Query ID: 01c39a0e-0212-6b00-24dd-070319383917
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:55.976000+00:00
-- Elapsed: 681ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
    TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
    CASE 
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 10 THEN 'Small'
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 50 THEN 'Medium'
      ELSE 'Large'
    END as bet_size_cat,
    CASE
      WHEN ACTIVE_DAYS_14D <= 3 THEN 'Low'
      WHEN ACTIVE_DAYS_14D <= 7 THEN 'Mid'
      ELSE 'High'
    END as engagement_cat,
    CASE
      WHEN LIFETIME_DEPOSIT_AMOUNT < 200 THEN 'Low_Dep'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 500 THEN 'Mid_Dep'
      ELSE 'High_Dep'
    END as deposit_cat
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
    AND AVG_CASH_BET_AMOUNT_PER_BET > 0
)
SELECT 
  ftu_cohort,
  bet_size_cat,
  engagement_cat,
  deposit_cat,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_d90_actual,
  ROUND(AVG(LTV_PRED_D90), 2) as avg_v2_pred
FROM bucketed
WHERE bet_size_cat = 'Medium' AND engagement_cat = 'Mid' AND deposit_cat = 'Mid_Dep'
GROUP BY 1, 2, 3, 4
ORDER BY 1
