-- Query ID: 01c39a29-0212-67a9-24dd-0703193e53d7
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T22:01:23.955000+00:00
-- Elapsed: 233595ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."CASHGGR" AS "CASHGGR",
  "Custom SQL Query"."EVENT_LEAGUE" AS "EVENT_LEAGUE",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."IN_PLAY_STAKE_COEFFICIENT" AS "IN_PLAY_STAKE_COEFFICIENT",
  CAST("Custom SQL Query"."LAST_BET_DATE" AS DATE) AS "LAST_BET_DATE",
  "Custom SQL Query"."LEG_SPORT_CATEGORY" AS "LEG_SPORT_CATEGORY",
  "Custom SQL Query"."LIFETIME_COMP_RATIO" AS "LIFETIME_COMP_RATIO",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."OPEN_HANDLE" AS "OPEN_HANDLE",
  "Custom SQL Query"."PRE_MATCH_STAKE_COEFFICIENT" AS "PRE_MATCH_STAKE_COEFFICIENT",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  WITH STATS AS (
  select
  account_id,
  vip_host,
  leg_sport_category,
  event_league,
  sum(total_cash_stake_by_legs) as Handle,
  sum(total_cash_ggr_by_legs) as CashGGR,
  sum(total_ngr_by_legs) as NGR
  from 
  fbg_analytics_engineering.trading.trading_sportsbook_mart a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.account_id
  where
  wager_status = 'SETTLED'
  and wager_channel = 'INTERNET'
  and is_test_wager = FALSE
  and vip_host is not null
  group by all
  ),
  
  open_stats AS (
  select
  account_id,
  vip_host,
  leg_sport_category,
  event_league,
  sum(total_cash_stake_by_legs) as open_handle
  from 
  fbg_analytics_engineering.trading.trading_sportsbook_mart a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.account_id
  where
  wager_status = 'ACCEPTED'
  and wager_channel = 'INTERNET'
  and is_test_wager = FALSE
  and vip_host is not null
  group by all
  ),
  
  last_bet AS (
  select
  account_id,
  vip_host,
  leg_sport_category,
  event_league,
  max(wager_placed_time_est) as last_bet_date
  from fbg_analytics_engineering.trading.trading_sportsbook_mart a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.account_id
  where wager_channel = 'INTERNET'
  and is_test_wager = FALSE
  and vip_host is not null
  group by all
  ),
  
  comp_calc AS (
  select
  a.acco_id,
  ifnull(sum(case when transaction = 'bonus awarded' and promo_type in ('cash_back') then amount else 0 end), 0) as Issued,
  sum(case when (transaction = 'bonus used' and promo_type = 'bonus_bet') or (transaction = 'bonus awarded' and promo_type = 'fancash') then amount * 0.6 else 0 end) as BBUsed,
  null AS ggr,
  null AS correction
  from FBG_P13N.PROMO_SILVER_TABLE.PROMOTIONS_LEDGER_FINAL a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.acco_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  (u.vip_host is not null or is_pvip = 1)
  and date <> '2024-09-08 07:36:50.715'
  and u.is_test_account = 'FALSE'
  group by all
  having (issued > 0 or bbused > 0)
  
  UNION
  
  select
  a.acco_id,
  sum(case when transaction = 'bonus awarded' and promo_type in ('casino_credit', 'cash_back') then amount else 0 end) as Issued,
  sum(case when transaction = 'bonus awarded' and promo_type = 'fancash' then amount * 0.6 else 0 end) as BBUsed,
  null AS ggr,
  null AS correction
  from fbg_analytics.product_and_customer.casino_promotions_ledger a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.acco_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  group by all
  having (issued > 0 or bbused > 0)
  
  UNION
  
  SELECT 
  c.acco_id, 
  null as Issued,
  null as BBUsed,
  ifnull(SUM(oc_cash_ggr), 0) AS GGR,
  null as correction
  FROM fbg_analytics.product_and_customer.customer_variable_profit C
  INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
  ON A.ID = C.Acco_ID
  INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart U
  ON U.Acco_ID = C.Acco_ID
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = c.acco_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  WHERE A.Test = 0
  AND date is not null
  and (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  GROUP BY ALL
  
  UNION
  
  select
  account_id as acco_id,
  null as Issued,
  null as BBUsed,
  ifnull(sum(total_cash_ggr_by_legs),0) as GGR,
  null as correction
  from fbg_analytics_engineering.trading.trading_sportsbook_mart a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.account_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.account_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  a.wager_status = 'SETTLED'
  and a.wager_channel = 'INTERNET'
  and (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  group by all
  
  UNION
  
  select
  a.acco_id as acco_id,
  null as Issued,
  null as BBUsed,
  null AS ggr,
  sum(amount) as correction
  from fbg_source.osb_source.account_statements a
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.acco_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  a.acco_id = 3427257
  and trans = 'CORRECTION'
  group by all
  ),
  
  comp_calc_final AS (
  SELECT DISTINCT 
  acco_id
  , sum(ifnull(Issued, 0)) + sum(ifnull(BBUsed, 0)) as Comp
  , sum(ifnull(GGR, 0)) - sum(ifnull(correction,0)) as GGR,
  FROM comp_calc
  GROUP BY
  ALL
  )
  -- RTC AS (
  -- select
  -- account_id,
  -- vip_host,
  -- sum(total_cash_stake_by_legs) as Handle1,
  -- sum(total_cash_ggr_by_legs) as CashGGR2,
  -- sum(total_ngr_by_legs) as NGR3,
  -- div0((ifnull(CashGGR2,0) - ifnull(NGR3, 0)), ifnull(CashGGR2, 0)) as LFTRTC
  -- from 
  -- fbg_analytics_engineering.trading.trading_sportsbook_mart a
  -- join fbg_analytics_engineering.customers.customer_mart u
  -- on u.acco_id = a.account_id
  -- where
  -- wager_status = 'SETTLED'
  -- and wager_channel = 'INTERNET'
  -- and is_test_wager = FALSE
  -- and vip_host is not null
  -- group by all
  -- )
  select
  d.account_id
  , u.status 
  , u.pre_match_stake_coefficient
  , u.in_play_stake_coefficient
  , d.vip_host
  , d.leg_sport_category
  , d.event_league
  , coalesce(a.Handle, 0) AS handle
  , coalesce(a.CashGGR, 0) AS cashggr
  , coalesce(a.NGR, 0) AS ngr
  , coalesce(c.open_handle, 0) AS open_handle
  , d.last_bet_date
  , coalesce(b.comp / nullif(b.ggr, 0), 0) AS lifetime_comp_ratio
  from last_bet AS d 
  LEFT JOIN stats a
      ON a.account_id = d.account_id
      AND a.vip_host = d.vip_host
      AND a.leg_sport_category = d.leg_sport_category
      AND a.event_league = d.event_league
  left join comp_calc_final b
      on b.acco_id = d.account_id
  LEFT JOIN open_stats AS c 
      ON d.account_id = c.account_id
      AND d.vip_host = c.vip_host
      AND d.leg_sport_category = c.leg_sport_category
      AND d.event_league = c.event_league
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart u
      on u.acco_id = d.account_id
) "Custom SQL Query"
