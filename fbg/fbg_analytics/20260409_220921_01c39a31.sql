-- Query ID: 01c39a31-0212-6dbe-24dd-0703193fcf03
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:09:21.816000+00:00
-- Elapsed: 55937ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."CURRENT_BALANCE" AS "CURRENT_BALANCE",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."TRADING_NGR" AS "TRADING_NGR",
  "Custom SQL Query"."TRADING_NGR_L30D" AS "TRADING_NGR_L30D",
  "Custom SQL Query"."TRADING_NGR_L7D" AS "TRADING_NGR_L7D",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  -- CASINO --
  with acc_statements as (
  select trans_date::date date,
      bet_id,
      acco_id,
      sum(case when trans = 'STAKE' then -amount else 0 end) as cash_handle,
      sum(case when trans like '%STAKE' then -amount else 0 end) - sum(case when trans = 'SETTLEMENT' then amount else 0 end) as trading_ngr_inc_jp_wins
  from fbg_source.osb_source.account_statements
  where game_id is not null
  --and trans_date::date = dateadd('day',-1,date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  and date(convert_timezone('UTC','America/Anchorage', trans_date)) = date(convert_timezone('UTC','America/Anchorage', current_timestamp))
  group by all
  ),
  
  jp_wins as (
      select 
          game_play_id,
          sum(win_amount) jp_wins
      from fbg_source.osb_source.jackpot_transactions where game_play_id = '25331723001568991'
      group by all
  )
  
  , acc_statements_l7d as (
  select trans_date::date date,
      bet_id,
      acco_id,
      sum(case when trans = 'STAKE' then -amount else 0 end) as cash_handle,
      sum(case when trans like '%STAKE' then -amount else 0 end) - sum(case when trans = 'SETTLEMENT' then amount else 0 end) as trading_ngr_inc_jp_wins
  from fbg_source.osb_source.account_statements
  where game_id is not null
  --and trans_date::date = dateadd('day',-1,date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  and date(convert_timezone('UTC','America/Anchorage', trans_date)) >= dateadd(day, -7, date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  group by all
  )
  
  , final_l7d as (
  select distinct 
  acco_id
  , sum(trading_ngr_inc_jp_wins) + sum(nvl(jp_wins,0)) as trading_ngr_l7d
  from acc_statements_l7d as a 
  left join jp_wins jpw
  on a.bet_id = jpw.game_play_id
  group by all
  )
  
  , acc_statements_l30d as (
  select trans_date::date date,
      bet_id,
      acco_id,
      sum(case when trans = 'STAKE' then -amount else 0 end) as cash_handle,
      sum(case when trans like '%STAKE' then -amount else 0 end) - sum(case when trans = 'SETTLEMENT' then amount else 0 end) as trading_ngr_inc_jp_wins
  from fbg_source.osb_source.account_statements
  where game_id is not null
  --and trans_date::date = dateadd('day',-1,date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  and date(convert_timezone('UTC','America/Anchorage', trans_date)) >= dateadd(day, -30, date(convert_timezone('UTC','America/Anchorage', current_timestamp)))
  group by all
  )
  
  , final_l30d as (
  select distinct 
  acco_id
  , sum(trading_ngr_inc_jp_wins) + sum(nvl(jp_wins,0)) as trading_ngr_l30d
  from acc_statements_l30d as a 
  left join jp_wins jpw
  on a.bet_id = jpw.game_play_id
  group by all
  )
  
  select
  a.acco_id,
  cm.vip_host,
  cm.lead_owner,
  cm.f1_loyalty_tier,
  fs.trading_ngr_l7d,
  ft.trading_ngr_l30d,
  ab.balance as current_balance,
  sum(cash_handle) cash_handle,
  sum(trading_ngr_inc_jp_wins) + sum(nvl(jp_wins,0)) as trading_ngr
  from acc_statements a
  left join jp_wins jpw
  on a.bet_id = jpw.game_play_id
  left join fbg_analytics_engineering.customers.customer_mart as cm 
  on a.acco_id = cm.acco_id
  left join final_l7d as fs 
  on a.acco_id = fs.acco_id
  left join final_l30d as ft
  on a.acco_id = ft.acco_id
  left join fbg_source.osb_source.account_balances as ab 
  on a.acco_id = ab.acco_id
  and ab.fund_type_id = 1
  where cm.is_test_account = FALSE
  group by all
  QUALIFY ROW_NUMBER() OVER (ORDER BY sum(cash_handle) DESC) <= 10
) "Custom SQL Query"
