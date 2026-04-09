-- Query ID: 01c39a32-0212-6cb9-24dd-070319403a8f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:10:27.949000+00:00
-- Elapsed: 15452ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."CURRENT_BALANCE" AS "CURRENT_BALANCE",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."OPEN_CASH_HANDLE" AS "OPEN_CASH_HANDLE",
  "Custom SQL Query"."TRADING_NGR" AS "TRADING_NGR",
  "Custom SQL Query"."TRADING_NGR_L30D" AS "TRADING_NGR_L30D",
  "Custom SQL Query"."TRADING_NGR_L7D" AS "TRADING_NGR_L7D",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  -- Sportsbook --
  
  
  with temp as(
  
  select  a.acco_id,
           SUM(   CASE
                      WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
                      ELSE a.total_stake
                  END) as cash_handle,
           SUM(   CASE
                      WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
                      ELSE a.total_stake
                  END)
          - SUM(COALESCE(a.payout,0)) AS trading_ngr
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
      ON a.id = sfsa.bet_id
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
      on a.acco_id = cm.acco_id
  
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('SETTLED')
  and a.channel = 'INTERNET'
  and date(convert_timezone('UTC','America/Anchorage', settlement_time)) = date(convert_timezone('UTC','America/Anchorage', current_timestamp))
  GROUP BY ALL
  )
  
  , temp_l7d as(
  
  select  a.acco_id,
           -- SUM(   CASE
           --            WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
           --            ELSE a.total_stake
           --        END) as cash_handle,
           SUM(   CASE
                      WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
                      ELSE a.total_stake
                  END)
          - SUM(COALESCE(a.payout,0)) AS trading_ngr_l7d
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
      ON a.id = sfsa.bet_id
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
      on a.acco_id = cm.acco_id
  
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('SETTLED')
  and a.channel = 'INTERNET'
  and date(convert_timezone('UTC','America/Anchorage', settlement_time)) >= dateadd(day, -7, date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  GROUP BY ALL
  )
  
  , temp_l30d as(
  
  select  a.acco_id,
           -- SUM(   CASE
           --            WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
           --            ELSE a.total_stake
           --        END) as cash_handle,
           SUM(   CASE
                      WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
                      ELSE a.total_stake
                  END)
          - SUM(COALESCE(a.payout,0)) AS trading_ngr_l30d
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
      ON a.id = sfsa.bet_id
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
      on a.acco_id = cm.acco_id
  
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('SETTLED')
  and a.channel = 'INTERNET'
  and date(convert_timezone('UTC','America/Anchorage', settlement_time)) >= dateadd(day, -30, date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  GROUP BY ALL
  )
  
  , open_handle_cte as (
  select  a.acco_id,
           SUM(   CASE
                      WHEN a.fancash_stake_amount > 0 OR a.FREE_BET = TRUE THEN 0
                      ELSE a.total_stake
                  END) as open_cash_handle
          
  from FBG_SOURCE.OSB_SOURCE.BETS as a
  
  LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
      ON a.id = sfsa.bet_id
  
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as cm
      on a.acco_id = cm.acco_id
  
  
  WHERE 1=1
  and cm.is_test_account = FALSE
  and a.status IN ('ACCEPTED')
  and a.channel = 'INTERNET'
  GROUP BY ALL
  )
  
  select
  a.acco_id,
  cm.vip_host,
  cm.lead_owner,
  cm.f1_loyalty_tier,
  ts.trading_ngr_l7d,
  tt.trading_ngr_l30d,
  coalesce(oh.open_cash_handle, 0) as open_cash_handle,
  ab.balance as current_balance,
  sum(cash_handle) cash_handle,
  sum(trading_ngr) as trading_ngr
  from temp a
  left join fbg_analytics_engineering.customers.customer_mart as cm 
      on a.acco_id = cm.acco_id
  left join temp_l7d as ts 
      on a.acco_id = ts.acco_id 
  left join temp_l30d as tt 
      on a.acco_id = tt.acco_id
  left join open_handle_cte as oh 
      on a.acco_id = oh.acco_id
  left join fbg_source.osb_source.account_balances as ab 
      on a.acco_id = ab.acco_id
      and ab.fund_type_id = 1
  group by all
  QUALIFY ROW_NUMBER() OVER (ORDER BY sum(trading_ngr) DESC) <= 10
) "Custom SQL Query"
