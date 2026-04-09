-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e44b7
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: STRATEGY_XL_WH
-- Executed: 2026-04-09T22:01:25.685000+00:00
-- Elapsed: 24045ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."FIRST_NJ_BET_DATE" AS "FIRST_NJ_BET_DATE",
  "Custom SQL Query"."LATEST_NJ_BET_DATE" AS "LATEST_NJ_BET_DATE",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  with ngr as(
  select
  acco_id,
  sum(coalesce(osb_finance_ngr,0)) + sum(coalesce(oc_finance_ngr,0)) as ngr
  from fbg_analytics.product_and_customer.customer_variable_profit
  group by all
  )
  
  select
  a.acco_id,
  c.vip_host,
  b.status,
  d.ngr,
  date(min(a.trans_date)) as first_nj_bet_date,
  date(max(a.trans_date)) as latest_nj_bet_date
  
  from fbg_source.osb_source.account_statements a
  inner join fbg_source.osb_source.accounts b
      on a.acco_id = b.id
  inner join fbg_analytics_engineering.customers.customer_mart c
      on a.acco_id = c.acco_id
  left join ngr d
      on a.acco_id = d.acco_id
  where a.jurisdictions_id = 7
  and a.trans IN ('STAKE', 'FREE_SPIN_STAKE', 'CASINO_CREDIT_STAKE', 'FREEBET_STAKE', 'SETTLEMENT')
  and b.test = 0
  group by all
) "Custom SQL Query"
