-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4fc7
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:02:30.736000+00:00
-- Elapsed: 83826ms
-- Environment: FBG

SELECT "Custom SQL Query"."% of Volume Through Trustly" AS "% of Volume Through Trustly",
  "Custom SQL Query"."Account ID" AS "Account ID",
  "Custom SQL Query"."Average Weekly Deposit Amount" AS "Average Weekly Deposit Amount",
  "Custom SQL Query"."Average Weekly Deposit Count" AS "Average Weekly Deposit Count",
  "Custom SQL Query"."Average Weekly WD Amount" AS "Average Weekly WD Amount",
  "Custom SQL Query"."Average Weekly WD Count" AS "Average Weekly WD Count",
  "Custom SQL Query"."Cash Handle" AS "Cash Handle",
  "Custom SQL Query"."Dep/WD Amount Ratio" AS "Dep/WD Amount Ratio",
  "Custom SQL Query"."Dep/WD Count Ratio" AS "Dep/WD Count Ratio",
  "Custom SQL Query"."Most Used Method" AS "Most Used Method",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."Payment Fees" AS "Payment Fees",
  "Custom SQL Query"."Payments % of NGR" AS "Payments % of NGR",
  "Custom SQL Query"."Product Preference" AS "Product Preference",
  "Custom SQL Query"."Trustly Tier" AS "Trustly Tier",
  "Custom SQL Query"."VIP Host" AS "VIP Host"
FROM (
  with retail_expected_ggr_table as (
  select
     date(wager_settlement_time_alk) as wager_date
     ,sum(total_ngr_by_wager) as retail_ngr
     ,account_id
  from
      fbg_analytics_engineering.trading.trading_sportsbook_mart
  where
      1=1
      and wager_status = 'SETTLED'
      and is_test_wager = FALSE
      and wager_channel = 'RETAIL'
  group by all
  )
  
  ,retail_table as (
  select
    date(trans_date_alk) as date
    ,retail_ngr
    ,account_id
  
  from
    fbg_finance.finance_mart.fct_finance_transactions
    inner join retail_expected_ggr_table on date = wager_date
  
  where
    1=1
    and date(trans_date_alk) >= '2025-01-01'
    and finance_transaction_source = 'RETAIL'
    and transaction_finance_location_id != 21
  
    --and account_id = '1778182'
  
  group by all
  )
  
  ,expected_ggr_table as (
  select
     date(wager_settlement_time_alk) wager_date,
     sum(TOTAL_STAKE_BY_LEGS * TOTAL_EXPECTED_HOLD_PCT_BY_WAGER) expected_ggr,
     t.account_id
  from FBG_ANALYTICS_ENGINEERING.TRADING.trading_sportsbook_mart t
  left join FBG_ANALYTICS_ENGINEERING.CUSTOMERS.customer_mart c on t.account_id = c.acco_id
  where
    1=1
    and wager_status = 'SETTLED'
    and is_test_wager = FALSE
    and wager_channel = 'INTERNET'
  
  group by all
  )
  
  ,osb_base_table as (
  
  select
    date(trans_date_alk) as date
    ,t.transaction_account_id
    ,sum(case when metric_name in ('BONUS_BET_WAGER_SETTLED','FANCASH_WAGER_SETTLED') then -transaction_amount else 0 end) as bonus_handle
    ,sum(case when metric_name in ('FREEBET_AWARDED','PURCHASE_MATCH','NONCASH_CANCELS','NONCASH_VOIDS') and transaction_fund_type_id <> 1 then transaction_amount else 0 
       end)*0.66 as bb_issued
    ,sum(case when metric_name in ('FANCASH_CONVERTED_EXPIRED','FREEBET_EXPIRED') then -transaction_amount else 0 end)*0.66 as bb_expiry
    ,sum(case when metric_name in ('FANCASH_EARN') then transaction_amount else 0 end)*0.66 as fancash_issued
    ,sum(case when metric_name in ('CASHBACK') then transaction_amount else 0 end) as sportsbookcashbonuses
  
  from FBG_FINANCE.FINANCE_MART.fct_finance_transactions t
  inner join FBG_ANALYTICS_ENGINEERING.CUSTOMERS.customer_mart c on t.transaction_account_id = c.acco_id
  
  where
    1=1
    and date(trans_date_alk) >= '2025-01-01'
    and finance_transaction_source = 'INTERNET'
    and (DATE_TRUNC(Year,DATE) = DATE_TRUNC(Year, DATEADD(Day,-1,Current_Date)) OR DATE(DATE) >= DATEADD(Day,-31,current_Date))
  group by all
  )
  
  ,osb_table as (
  select
    b.date
    ,e.account_id
    ,e.expected_ggr - bb_issued + bb_expiry - fancash_issued - sportsbookcashbonuses - bonus_handle*0.34 as expected_finance_ngr
  
  from osb_base_table b
  inner join expected_ggr_table e on (b.date = e.wager_date and b.transaction_account_id = e.account_id)
  )
  
  ,stg as (
  select 
    date_trunc('day',p.date) as day
    ,round(p.acco_id) as acco_id
    ,r.retail_ngr
    ,sum(p.oc_ngr) as Casino_ngr
    ,o.expected_finance_ngr as Sportsbook_eNGR
    ,sum(payment_fees) as PaymentFees
    ,SUM(ifnull(p.osb_cash_handle,0)) + SUM(ifnull(p.oc_cash_handle,0)) as cashhandle
  
  from fbg_analytics.product_and_customer.customer_variable_profit p 
  left join retail_table r on (r.date = date(p.date) and round(p.acco_id) = r.account_id)
  left join osb_table o on (o.date = date(p.date) and o.account_id = round(p.acco_id)) 
  where 
    1 = 1 
  group by all 
  order by 1 DESC
  )
  ,
  
  erev as(
  select
    day
    ,acco_id
    ,ifnull(retail_ngr,0) + ifnull(casino_ngr,0) + ifnull(sportsbook_eNGR,0) as eRevenue
    ,paymentfees
    ,cashhandle
  from stg
  ) 
  ,
  
  
  step1 as (SELECT 
  u.Acco_ID AS "Account ID",
  u.vip_host as "VIP Host",
  u.is_test_account,
  --date(current_date) as datecheck,
  --Tier as "Trustly Tier",
  COALESCE(U.Current_STate, U.Registration_state) AS "State",
  --SUM(ifnull(c.oc_engr,0)) + SUM(ifnull(c.osb_engr,0)) as "eNGR",
  SUM(ifnull(eRevenue,0)) as "NGR", -- ACTUALLY erev
  SUM(ifnull(cashhandle,0)) as "Cash Handle",
  SUM(paymentfees) AS "Payment Fees",
  --SUM(payment_fees) / nullif(SUM(ifnull(c.oc_engr,0)) + SUM(ifnull(c.osb_engr,0)),0) as "Payments % of eNGR",
  SUM(paymentfees) / nullif(SUM(ifnull(eRevenue,0)),0) as "Payments % of NGR",
  product_preference as "Product Preference"
  FROM  erev c
  LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART U
  on u.acco_id = c.acco_id
  --left join fbg_analytics.operations.trustly_vip_tiers_historical t on c.acco_id = t.account_id and datecheck = t.date_value
  where 1=1
  and (u.is_casino_vip = 1 or u.is_vip = 1)
  and u.is_test_account = 0
  and day >= '2025-01-01'
  and status = 'ACTIVE'
  GROUP BY ALL
  order by "Payment Fees" asc)
  --select * from step1;
  ,
  
  test as (
  select "Account ID", "VIP Host", "NGR", "Payments % of NGR"
  from step1 
  where "Payments % of NGR" >= 0.08
  and "VIP Host" is not null
  order by "Payments % of NGR" desc
  )
  --select * from test;
  ,
  
  
  setup as (select d.*, tier, from 
  fbg_source.osb_source.deposits d
  left join fbg_analytics.operations.trustly_vip_tiers_historical l on 
  d.acco_id = l.account_id and date(d.created) = l.date_value
  where status = 'DEPOSIT_SUCCESS' and payment_brand not in ('TERMINAL','CASHATCAGE','PAYSAFECASH')
  and acco_id in (select "Account ID" from test)
  and created >= date_trunc('week', current_date) - interval '1 week'
  and created < date_trunc('week', current_date)
  order by created desc)
  ,
  
  trustly as(
  select acco_id,
  sum(amount) as totalvolume,
  zeroifnull(sum(Case when payment_brand in ('TRUSTLY') then amount end)) as totalTrustlyVolume,
  totaltrustlyvolume/totalvolume as "% of Volume Through Trustly"
  from setup
  where created >= date_trunc('week', current_date) - interval '1 week'
  and created < date_trunc('week', current_date)
  group by all
  )
  
  , 
  
  average as (
  select date_trunc('week',created) as week, acco_id, count(*) as count, avg(amount) as amount
  from fbg_source.osb_source.deposits
  where created >= date_trunc('year',current_date)
  and status = 'DEPOSIT_SUCCESS'
  and acco_id in (select "Account ID" from test)
  group by all
  ),
  
  avg2 as (
  select acco_id, avg(count) as "Average Weekly Deposit Count", avg(amount) as "Average Weekly Deposit Amount"
  from average
  group by all
  ),
  
  wdaverage as (
  select date_trunc('week',initiated_at) as week, account_id, count(*) as count, avg(amount) as amount
  from fbg_source.osb_source.withdrawals
  where initiated_at >= date_trunc('year',current_date)
  and status = 'WITHDRAWAL_COMPLETED'
  and account_id in (select "Account ID" from test)
  group by all
  ),
  
  wdavg2 as (
  select account_id, avg(count) as "Average Weekly WD Count", avg(amount) as "Average Weekly WD Amount"
  from wdaverage
  group by all
  ),
  
  method as(
  select acco_id, payment_brand, count(created) as methodcount, 
  row_number() over (partition by acco_id order by methodcount desc) as rn
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS'
  and created >= date_trunc('year',current_date)
  and acco_id in (select "Account ID" from test)
  group by all
  )
  ,
  
  method2 as (
  select acco_id, payment_brand as "Most Used Method"
  from method
  where rn = 1
  ),
  
  tier as (
  select accounts_id, 
  case when customer_segments_id = 3201 then 'Trustly Tier 1'
  when customer_segments_id = 3202 then 'Trustly Tier 2'
  when customer_segments_id = 3203 then 'Trustly Tier 3'
  when customer_segments_id = 3204 then 'Trustly Tier 4'
  when customer_segments_id = 3205 then 'Trustly Tier 5'
  when customer_segments_id = 22664 then 'Trustly Tier 99'
  else null end as "Trustly Tier"
  from fbg_source.osb_source.account_segments
  where customer_segments_id in (3201, 3202, 3203, 3204, 3205, 22664)
  )
  
  
  select "Account ID", "VIP Host", "Trustly Tier", "NGR", "Payments % of NGR", "% of Volume Through Trustly", "Average Weekly Deposit Count", "Average Weekly Deposit Amount","Payment Fees", "Most Used Method", "Cash Handle", "Product Preference", "Average Weekly WD Count", "Average Weekly WD Amount", "Average Weekly Deposit Count"/"Average Weekly WD Count" as "Dep/WD Count Ratio", "Average Weekly Deposit Amount"/"Average Weekly WD Amount" as "Dep/WD Amount Ratio"
  from step1 s
  left join trustly t
  on s."Account ID" = t.acco_id
  left join avg2 a
  on s."Account ID" = a.acco_id
  left join method2 m
  on s."Account ID" = m.acco_id
  left join tier z
  on s."Account ID" = z.accounts_id
  left join wdavg2 w
  on s."Account ID" = w.account_id
  where "Payments % of NGR" >= 0.08
  and "VIP Host" is not null
  order by "Payment Fees" desc
) "Custom SQL Query"
