-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e49ef
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:01:56.353000+00:00
-- Elapsed: 17988ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."CH" AS "CH",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."TOTAL_HANDLE" AS "TOTAL_HANDLE",
  "Custom SQL Query"."TW" AS "TW"
FROM (
  select
      to_date(date_trunc(day,b.wager_settlement_time_est)) as day,
      --live_bet,
      sum(total_cash_stake_by_legs) + sum(total_non_cash_stake_by_legs) as total_handle,
      sum(total_cash_stake_by_legs) as ch,
      --SUM(total_cash_stake_by_legs) - SUM(TOTAL_PAYOUT_BY_LEGS - (wager_boost_payout/number_of_lines_by_wager)) as TW,
      sum(trading_win) as TW,
      --Sum(total_cash_stake_by_legs) - sum(TOTAL_PAYOUT_BY_LEGS + total_winnings_bonus_by_legs) as NGR,
      sum(total_ngr_by_legs) as ngr
      from fbg_analytics_engineering.trading.trading_sportsbook_mart b
      where WAGER_CHANNEL = 'INTERNET'
      and WAGER_STATUS = 'SETTLED'
      AND is_test_wager = FALSE
      --and free_bet = FALSE
      group by all
      order by day desc
) "Custom SQL Query"
