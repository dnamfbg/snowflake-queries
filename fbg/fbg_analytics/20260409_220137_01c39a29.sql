-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e7057
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:01:37.072000+00:00
-- Elapsed: 11377ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."PUNCH_CARD_CATEGORY" AS "PUNCH_CARD_CATEGORY",
  "Custom SQL Query"."PUNCH_CARD_HIT" AS "PUNCH_CARD_HIT"
FROM (
  --Punch card Query
  with status_matches as (
  select 
  acco_id,
  status_match_start_date,
  status_match_end_date
  from fbg_analytics.product_and_customer.status_match
  where 1=1
  and date(status_match_start_date) >= '2025-01-01'
  and status_match_tier_name in ('ONEgold', 'ONEplatinum', 'ONEblack')
  ),
  
  deposits as (
   SELECT 
   o.acco_id,
   COALESCE(SUM(d.deposit_amount),0) AS deposit_sum,
   case
      when COALESCE(SUM(d.deposit_amount),0) >= 50 
          then 1
      else 0
  end as deposit_punch_card_requirement
   from status_matches o 
   JOIN fbg_analytics.vip.deposits_withdrawals d
   on o.acco_id = d.acco_id
     AND DATE(d.date) BETWEEN o.status_match_start_date AND o.status_match_end_date
  group by all
  ),
  
   first14_daily_handle AS (
    SELECT
      o.acco_id,
      DATE(cvp.date) AS wager_date,
      SUM(COALESCE(cvp.OSB_CASH_HANDLE, 0) + COALESCE(cvp.OC_CASH_HANDLE, 0)) AS total_handle
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
    JOIN status_matches o
      ON cvp.acco_id = o.acco_id
      -- first 14 days inclusive: start_date through start_date + 13
      AND DATE(cvp.date) BETWEEN o.status_match_start_date AND DATEADD(day, 13, o.status_match_start_date)
    GROUP BY
      o.acco_id,
      DATE(cvp.date)
  ),
  
   first14_punchcard AS (
    SELECT
      acco_id,
      SUM(CASE WHEN total_handle >= 10 THEN 1 ELSE 0 END) AS days_wagered_10_first14,
      CASE WHEN SUM(CASE WHEN total_handle >= 10 THEN 1 ELSE 0 END) >= 5 THEN 1 ELSE 0 END AS handle_punch_card_requirement
    FROM first14_daily_handle
    GROUP BY acco_id
  ),
  
  sgp_check as (
  select distinct 
  account_id as acco_id,
  wager_id,
  wager_settlement_time_alk
  from fbg_analytics_engineering.trading.trading_sportsbook_mart a
  join status_matches o
      ON a.account_id = o.acco_id
  where number_of_lines_by_wager >= 3
  and total_cash_stake_by_wager >= 25
  and wager_status = 'SETTLED'
  and total_price_by_wager >= 4
  and date(wager_settlement_time_alk) 
      between o.status_match_start_date and o.status_match_end_date
  ),
  
  sgp_punch_card_check as (
  select 
  acco_id,
  count(distinct wager_id) as sgp_count,
  case
      when count(distinct wager_id) > 0 
          then 1 else 0
  end as sgp_punch_card_requirement
  from sgp_check
  group by acco_id
  ),
  
  base as (
  select
  a.acco_id,
  sgp.sgp_punch_card_requirement,
  f14.handle_punch_card_requirement,
  dep.deposit_punch_card_requirement
  from status_matches a
  left join sgp_punch_card_check sgp
      on a.acco_id = sgp.acco_id
  left join first14_punchcard f14
      on a.acco_id = f14.acco_id
  left join deposits dep
      on a.acco_id = dep.acco_id
  )
  
  SELECT
    acco_id,
    '14 Day Handle (5 of 14 days >= $10)' AS punch_card_category,
    handle_punch_card_requirement AS punch_card_hit
  FROM base
  
  UNION ALL
  
  SELECT
    acco_id,
    'Same Game Parlay' AS punch_card_category,
    sgp_punch_card_requirement AS punch_card_hit
  FROM base
  
  UNION ALL
  
  SELECT
    acco_id,
    'Deposits >= $50' AS punch_card_category,
    deposit_punch_card_requirement AS punch_card_hit
  FROM base
) "Custom SQL Query"
