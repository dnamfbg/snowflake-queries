-- Query ID: 01c39a56-0212-6dbe-24dd-07031947f277
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:46:16.183000+00:00
-- Elapsed: 8198ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."TRADING_WIN" AS "TRADING_WIN",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  SELECT ACCOUNT_ID,
  cm.vip_host,
  sum(case when is_free_bet_wager = FALSE then trading_win else 0 end) as trading_win,
  SUM(CASE WHEN is_free_bet_wager = FALSE THEN total_cash_stake_by_legs END) AS Cash_Handle
  FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART a
  inner join FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART cm
      on a.account_id = cm.acco_id
  WHERE wager_channel  = 'INTERNET'
  AND wager_status = 'SETTLED'
  AND is_free_bet_wager = FALSE 
  AND (cm.is_vip = TRUE or cm.is_casino_vip = TRUE or cm.vip_host is not null)
  GROUP BY ALL
) "Custom SQL Query"
