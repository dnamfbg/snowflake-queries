-- Query ID: 01c39a06-0212-6cb9-24dd-07031935cc3b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:26:50.105000+00:00
-- Elapsed: 386ms
-- Environment: FBG

SELECT 
  DATE_TRUNC('month', D14) as cohort_month,
  COUNT(*) as customers,
  ROUND(AVG(LIFETIMEDEPOSITAMOUNT), 2) as avg_lifetime_dep,
  ROUND(AVG(LIFETIMEDEPOSITCOUNT), 2) as avg_deposit_count,
  ROUND(AVG(SUCCESSFULWITHDRAWALAMOUNT), 2) as avg_withdrawal,
  ROUND(AVG(SUCCESSFULWITHDRAWALCOUNT), 2) as avg_withdrawal_count,
  ROUND(AVG(TOTAL_TIME), 2) as avg_session_time_min,
  ROUND(AVG(SESSION_COUNT), 2) as avg_sessions,
  ROUND(AVG(CASH_BET_AMOUNT) / NULLIF(AVG(LIFETIMEDEPOSITAMOUNT), 0) * 100, 1) as handle_to_deposit_ratio
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1
ORDER BY 1
