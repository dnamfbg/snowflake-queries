-- Query ID: 01c39a0e-0212-6dbe-24dd-070319386067
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:57.775000+00:00
-- Elapsed: 550ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
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
    END as bet_freq_tier,
    CASE 
      WHEN SPORTSBOOK_FTU_DATE_ALK < '2025-09-01' THEN 'Pre-Sept-2025'
      ELSE 'Post-Sept-2025'
    END as period
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
)
SELECT 
  period,
  bet_size_tier,
  bet_freq_tier,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90,
  ROUND(AVG(D90CASH_HANDLE) - AVG(CASH_BET_AMOUNT), 2) as avg_incremental_d15_d90,
  ROUND(AVG(LTV_PRED_D90), 2) as avg_v2_pred
FROM bucketed
WHERE bet_size_tier != 'No Bets'
GROUP BY 1, 2, 3
HAVING COUNT(*) > 500
ORDER BY 2, 3, 1
