-- Query ID: 01c39a16-0212-67a9-24dd-07031939fbf7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:42:40.171000+00:00
-- Elapsed: 263ms
-- Environment: FBG

WITH bucketed AS (
  SELECT *,
    TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
    CASE 
      WHEN LIFETIME_DEPOSIT_AMOUNT < 100 THEN '$0-100'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 300 THEN '$100-300'
      WHEN LIFETIME_DEPOSIT_AMOUNT < 1000 THEN '$300-1000'
      ELSE '$1000+'
    END AS deposit_tier,
    CASE
      WHEN ACTIVE_DAYS_14D <= 3 THEN '1-3 days'
      WHEN ACTIVE_DAYS_14D <= 7 THEN '4-7 days'
      ELSE '8-14 days'
    END AS active_tier
  FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
  WHERE D90 <= CURRENT_DATE()
    AND SPORTSBOOK_FTU_DATE_ALK >= '2025-01-01'
    AND SPORTSBOOK_FTU_DATE_ALK < '2026-01-01'
)
SELECT 
  ftu_cohort,
  deposit_tier,
  active_tier,
  COUNT(*) AS customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) AS avg_d14_handle,
  ROUND(AVG(D90CASH_HANDLE), 2) AS avg_actual_d90,
  ROUND(AVG(D90CASH_HANDLE) - AVG(CASH_BET_AMOUNT), 2) AS avg_incremental_d15_d90,
  ROUND(SUM(D90CASH_HANDLE), 0) AS total_actual_d90
FROM bucketed
WHERE deposit_tier IN ('$100-300', '$300-1000')
  AND active_tier IN ('4-7 days', '8-14 days')
GROUP BY 1, 2, 3
HAVING COUNT(*) > 100
ORDER BY 2, 3, 1
