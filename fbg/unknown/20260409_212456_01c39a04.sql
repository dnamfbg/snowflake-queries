-- Query ID: 01c39a04-0212-67a9-24dd-07031935a703
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:24:56.560000+00:00
-- Elapsed: 609ms
-- Environment: FBG

SELECT 
  DATE_TRUNC('month', D14) as cohort_month,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_cash_handle,
  ROUND(AVG(AVG_CASH_BET_AMOUNT_PER_BET), 2) as avg_bet_size,
  ROUND(AVG(CASH_BET_COUNT), 2) as avg_cash_bet_count,
  ROUND(AVG(TOTAL_BETS), 2) as avg_total_bets,
  ROUND(AVG(FREE_BET_AMOUNT), 2) as avg_free_bet_amt,
  ROUND(AVG(LIVE_BET_COUNT), 2) as avg_live_bets,
  ROUND(AVG(SGP_BET_COUNT), 2) as avg_sgp_bets,
  ROUND(AVG(SINGLE_BET_COUNT), 2) as avg_single_bets,
  ROUND(AVG(AVG_BETS_PER_DAY), 2) as avg_bets_per_day,
  ROUND(AVG(TOTAL_TIME), 2) as avg_session_time,
  ROUND(AVG(SESSION_COUNT), 2) as avg_sessions,
  ROUND(AVG(D14NGR), 2) as avg_d14ngr,
  ROUND(AVG(BONUS_COSTS), 2) as avg_bonus_costs,
  ROUND(AVG(AMOUNT_PROMO_COST), 2) as avg_promo_cost,
  ROUND(AVG(NUM_PROMO_AWARDED), 2) as avg_promos,
  ROUND(AVG(LIFETIMEDEPOSITAMOUNT), 2) as avg_lifetime_dep,
  ROUND(AVG(AGE), 1) as avg_age,
  ROUND(AVG(SUCCESSFULWITHDRAWALAMOUNT), 2) as avg_withdrawal
FROM fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS
GROUP BY 1
ORDER BY 1
