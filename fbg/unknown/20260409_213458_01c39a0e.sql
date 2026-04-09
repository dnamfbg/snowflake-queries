-- Query ID: 01c39a0e-0212-6dbe-24dd-070319386083
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:58.510000+00:00
-- Elapsed: 242ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
    CASE 
      WHEN LIFETIME_DEPOSIT_AMOUNT <= 0 OR LIFETIME_DEPOSIT_AMOUNT IS NULL THEN '$0'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 100 THEN '$1-100'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 300 THEN '$100-300'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 500 THEN '$300-500'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 1000 THEN '$500-1000'
      ELSE '$1000+'
    END as deposit_tier,
    CASE
      WHEN ACTIVE_DAYS_14D <= 2 THEN '1-2 days'
      WHEN ACTIVE_DAYS_14D <= 5 THEN '3-5 days'
      WHEN ACTIVE_DAYS_14D <= 9 THEN '6-9 days'
      ELSE '10-14 days'
    END as active_days_tier,
    CASE 
      WHEN SPORTSBOOK_FTU_DATE_ALK < '2025-09-01' THEN 'Pre-Sept-2025'
      ELSE 'Post-Sept-2025'
    END as period
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
)
SELECT 
  period,
  deposit_tier,
  active_days_tier,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) as avg_actual_d90,
  ROUND(AVG(D90CASH_HANDLE) - AVG(CASH_BET_AMOUNT), 2) as avg_incremental_d15_d90
FROM bucketed
GROUP BY 1, 2, 3
HAVING COUNT(*) > 500
ORDER BY 2, 3, 1
