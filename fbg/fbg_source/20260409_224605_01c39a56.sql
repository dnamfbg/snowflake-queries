-- Query ID: 01c39a56-0212-67a8-24dd-07031947d597
-- Database: FBG_SOURCE
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Executed: 2026-04-09T22:46:05.207000+00:00
-- Elapsed: 112ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."TRADING_WIN" AS "TRADING_WIN"
FROM (
  SELECT ACCOUNT_ID,
  sum(case when is_free_bet_wager = FALSE then trading_win else 0 end) as trading_win,
  SUM(CASE WHEN is_free_bet_wager = FALSE THEN total_cash_stake_by_legs END) AS Cash_Handle
  FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART 
  WHERE wager_channel  = 'INTERNET'
  AND wager_status = 'SETTLED'
  AND is_free_bet_wager = FALSE 
  GROUP BY 1
) "Custom SQL Query"
