-- Query ID: 01c39a47-0212-6e7d-24dd-070319449cdf
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:31:09.797000+00:00
-- Elapsed: 1939ms
-- Environment: FBG

SELECT "Custom SQL Query9"."ACCO_ID" AS "ACCO_ID (Custom SQL Query9)",
  "Custom SQL Query9"."BALANCE" AS "BALANCE"
FROM (
  with account_balances_ranked as (
  select 
  a.acco_id,
  ab.balance,
  row_number() over (partition by a.acco_id order by ab.last_updated desc) as balance_rank
  from fbg_analytics.product_and_customer.fast_track_attribute a 
  join FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES ab
      on a.acco_id = ab.acco_id
  group by a.acco_id, ab.balance, ab.last_updated
  )
  
  select 
  acco_id,
  balance
  from account_balances_ranked
  where balance_rank = 1
) "Custom SQL Query9"
