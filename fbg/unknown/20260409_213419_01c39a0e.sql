-- Query ID: 01c39a0e-0212-67a8-24dd-0703193817d7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:34:19.173000+00:00
-- Elapsed: 2019ms
-- Environment: FBG

SELECT 
  TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  COUNT(*) as customers,
  ROUND(AVG(BONUS_COSTS), 2) as avg_bonus_costs,
  ROUND(AVG(ACQ_BONUS_COSTS), 2) as avg_acq_bonus_costs,
  ROUND(AVG(RET_BONUS_COSTS), 2) as avg_ret_bonus_costs,
  ROUND(AVG(AMOUNT_PROMO_COST), 2) as avg_promo_cost,
  ROUND(AVG(NUM_PROMO_AWARDED), 2) as avg_promos_awarded,
  ROUND(AVG(NUM_PROMO_CLAIMED), 2) as avg_promos_claimed,
  ROUND(AVG(AMOUNT_BONUSBET_AWARDED), 2) as avg_bonusbet_awarded,
  ROUND(AVG(AMOUNT_FANCASH_AWARDED), 2) as avg_fancash_awarded,
  ROUND(AVG(AMOUNT_PROFIT_BOOST_AWARDED), 2) as avg_profitboost_awarded,
  ROUND(AVG(BB_COSTS), 2) as avg_bb_costs,
  ROUND(AVG(FC_COSTS), 2) as avg_fc_costs,
  ROUND(AVG(PROFIT_BOOST_COSTS), 2) as avg_pb_costs,
  ROUND(AVG(LIFETIME_DEPOSIT_AMOUNT), 2) as avg_lifetime_dep,
  ROUND(AVG(LIFETIME_DEPOSIT_COUNT), 2) as avg_dep_count,
  ROUND(AVG(SUCCESSFUL_WITHDRAWAL_AMOUNT), 2) as avg_withdrawal,
  ROUND(AVG(SUCCESSFUL_WITHDRAWAL_COUNT), 2) as avg_withdrawal_count
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
GROUP BY 1
ORDER BY 1
