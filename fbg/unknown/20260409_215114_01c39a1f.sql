-- Query ID: 01c39a1f-0212-644a-24dd-0703193c0433
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:51:14.160000+00:00
-- Elapsed: 259ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
    TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
    CASE 
      WHEN AVG_CASH_BET_AMOUNT_PER_BET = 0 OR AVG_CASH_BET_AMOUNT_PER_BET IS NULL THEN 'No Bets'
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 10 THEN '$0-10'
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 25 THEN '$10-25'
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 50 THEN '$25-50'
      WHEN AVG_CASH_BET_AMOUNT_PER_BET < 100 THEN '$50-100'
      ELSE '$100+'
    END as bet_size_tier,
    CASE 
      WHEN CASH_BET_COUNT = 0 OR CASH_BET_COUNT IS NULL THEN '0 bets'
      WHEN CASH_BET_COUNT <= 5 THEN '1-5 bets'
      WHEN CASH_BET_COUNT <= 15 THEN '6-15 bets'
      WHEN CASH_BET_COUNT <= 30 THEN '16-30 bets'
      ELSE '30+ bets'
    END as bet_freq_tier
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
    AND SPORTSBOOK_FTU_DATE_ALK >= '2025-01-01' AND SPORTSBOOK_FTU_DATE_ALK < '2026-01-01'
    AND AVG_CASH_BET_AMOUNT_PER_BET > 0
)
SELECT 
  ftu_cohort,
  bet_size_tier,
  bet_freq_tier,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90,
  ROUND(AVG(D90CASH_HANDLE) - AVG(CASH_BET_AMOUNT), 2) as avg_incremental_d15_d90,
  ROUND(AVG(LTV_PRED_D90), 2) as avg_v2_pred
FROM bucketed
WHERE bet_size_tier IN ('$10-25', '$25-50') AND bet_freq_tier IN ('6-15 bets', '16-30 bets')
GROUP BY 1, 2, 3
HAVING COUNT(*) > 100
ORDER BY 2, 3, 1
