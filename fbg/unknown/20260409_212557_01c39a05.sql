-- Query ID: 01c39a05-0212-6b00-24dd-07031935d37b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:25:57.290000+00:00
-- Elapsed: 192ms
-- Environment: FBG

SELECT 
  CASE WHEN D14 < '2025-09-01' THEN 'Pre-Sept-2025' ELSE 'Post-Sept-2025' END as period,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_cash_handle,
  ROUND(AVG(CASH_BET_COUNT), 2) as avg_cash_bets,
  ROUND(AVG(AVG_CASH_BET_AMOUNT_PER_BET), 2) as avg_bet_size,
  ROUND(AVG(FREE_BET_AMOUNT), 2) as avg_free_bet_amt,
  ROUND(AVG(LIVE_BET_COUNT), 2) as avg_live_bets,
  ROUND(AVG(SGP_BET_COUNT), 2) as avg_sgp_bets,
  ROUND(AVG(D14NGR), 2) as avg_ngr,
  ROUND(AVG(BONUS_COSTS), 2) as avg_bonus_costs,
  ROUND(AVG(LIFETIMEDEPOSITAMOUNT), 2) as avg_lifetime_dep
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
WHERE CURRENT_VALUE_BAND = 'Superfan'
GROUP BY 1
ORDER BY 1
