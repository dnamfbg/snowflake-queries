-- Query ID: 01c39a14-0212-644a-24dd-07031939d14b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:40:31.464000+00:00
-- Elapsed: 920ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
    TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
    CASE 
      WHEN AVG_CASH_BET_AMOUNT_PER_BET >= 10 AND AVG_CASH_BET_AMOUNT_PER_BET < 50 THEN 'Medium'
      ELSE 'Other'
    END AS bet_size_cat,
    CASE
      WHEN ACTIVE_DAYS_14D >= 4 AND ACTIVE_DAYS_14D <= 7 THEN 'Mid'
      ELSE 'Other'
    END AS engagement_cat,
    CASE
      WHEN LIFETIME_DEPOSIT_AMOUNT >= 200 AND LIFETIME_DEPOSIT_AMOUNT < 500 THEN 'Mid_Dep'
      ELSE 'Other'
    END AS deposit_cat
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
    AND SPORTSBOOK_FTU_DATE_ALK >= '2025-01-01'
    AND SPORTSBOOK_FTU_DATE_ALK < '2026-01-01'
)
SELECT 
  ftu_cohort,
  COUNT(*) AS customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) AS avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) AS avg_actual_d90,
  ROUND(AVG(D90CASH_HANDLE) - AVG(CASH_BET_AMOUNT), 2) AS avg_incr_d15_d90,
  ROUND(SUM(CASH_BET_AMOUNT), 0) AS total_d14_handle,
  ROUND(SUM(D90CASH_HANDLE), 0) AS total_actual_d90,
  ROUND(SUM(LTV_PRED_D90), 0) AS total_v2_pred_d90,
  ROUND(AVG(LTV_PRED_D90), 2) AS avg_v2_pred_d90,
  ROUND(AVG(FREE_BET_AMOUNT), 2) AS avg_free_bet,
  ROUND(AVG(AMOUNT_BONUSBET_AWARDED), 2) AS avg_bonusbet,
  ROUND(AVG(AMOUNT_FANCASH_AWARDED), 2) AS avg_fancash
FROM bucketed
WHERE bet_size_cat = 'Medium' AND engagement_cat = 'Mid' AND deposit_cat = 'Mid_Dep'
GROUP BY 1
ORDER BY 1
