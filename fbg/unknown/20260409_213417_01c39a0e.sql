-- Query ID: 01c39a0e-0212-67a9-24dd-07031937eccb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:17.447000+00:00
-- Elapsed: 1516ms
-- Environment: FBG

SELECT 
  TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  COUNT(*) as customers,
  ROUND(AVG(CASH_BET_AMOUNT), 2) as avg_d14_cash_handle,
  ROUND(AVG(CASH_BET_COUNT), 2) as avg_cash_bet_count,
  ROUND(AVG(TOTAL_BETS), 2) as avg_total_bets,
  ROUND(AVG(AVG_CASH_BET_AMOUNT_PER_BET), 2) as avg_bet_size,
  ROUND(AVG(AVG_BETS_PER_DAY), 2) as avg_bets_per_day,
  ROUND(AVG(FREE_BET_AMOUNT), 2) as avg_free_bet_amt,
  ROUND(AVG(FREE_BET_COUNT), 2) as avg_free_bet_count,
  ROUND(AVG(LIVE_BET_COUNT), 2) as avg_live_bets,
  ROUND(AVG(SGP_BET_COUNT), 2) as avg_sgp_bets,
  ROUND(AVG(SINGLE_BET_COUNT), 2) as avg_single_bets,
  ROUND(AVG(MULTIPLE_BET_COUNT), 2) as avg_multiple_bets,
  ROUND(AVG(D14NGR), 2) as avg_d14ngr,
  ROUND(AVG(AVG_NGR_PER_BET), 2) as avg_ngr_per_bet,
  ROUND(AVG(ACTIVE_DAYS_14D), 2) as avg_active_days,
  ROUND(AVG(CASH_ACTIVE_DAYS_14D), 2) as avg_cash_active_days,
  ROUND(AVG(UNIQUE_SPORTS_BET_ON), 2) as avg_unique_sports,
  ROUND(AVG(IS_SINGLE_BETTOR), 2) as pct_single_bettor
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
GROUP BY 1
ORDER BY 1
