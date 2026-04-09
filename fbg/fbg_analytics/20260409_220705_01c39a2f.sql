-- Query ID: 01c39a2f-0212-67a9-24dd-0703193f486b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:07:05.280000+00:00
-- Elapsed: 16470ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."COHORT_SIZE" AS "COHORT_SIZE",
  "Custom SQL Query"."CONTEST_START_STATUS" AS "CONTEST_START_STATUS",
  "Custom SQL Query"."CURRENT_STATUS" AS "CURRENT_STATUS",
  "Custom SQL Query"."NCAA_BASKETBALL_FLAG" AS "NCAA_BASKETBALL_FLAG",
  "Custom SQL Query"."PRODUCT_PREFERENCE" AS "PRODUCT_PREFERENCE",
  "Custom SQL Query"."TOTAL_CONTEST_CASH_HANDLE" AS "TOTAL_CONTEST_CASH_HANDLE",
  "Custom SQL Query"."TOTAL_CONTEST_OSB_BETS" AS "TOTAL_CONTEST_OSB_BETS",
  "Custom SQL Query"."TOTAL_CONTEST_OSB_CASH_BETS" AS "TOTAL_CONTEST_OSB_CASH_BETS",
  "Custom SQL Query"."TOTAL_CONTEST_OSB_CASH_EGGR" AS "TOTAL_CONTEST_OSB_CASH_EGGR",
  "Custom SQL Query"."TOTAL_CONTEST_OSB_CASH_GGR" AS "TOTAL_CONTEST_OSB_CASH_GGR",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."WEEKEND_1_BET_DAYS" AS "WEEKEND_1_BET_DAYS",
  "Custom SQL Query"."WEEKEND_1_POINTS" AS "WEEKEND_1_POINTS",
  "Custom SQL Query"."WEEKEND_2_BET_DAYS" AS "WEEKEND_2_BET_DAYS",
  "Custom SQL Query"."WEEKEND_2_POINTS" AS "WEEKEND_2_POINTS"
FROM (
  with eligible_customers  as (
      select 
          a.vip_host,
          a.acco_id,
          a.status as contest_start_status,
          v.status as current_status
      from fbg_analytics.vip.march_madness_comp_2026_03_19 a
      left join fbg_analytics_engineering.customers.customer_mart v
          on a.acco_id = v.acco_id
  ),
  
  -- select *
  -- from eligible_customers
  --6789
  
  host_assignment AS (
      select 
          p.vip_host, 
          e.host_type, 
          e.external_title, 
          e.internal_title, 
          e.focus, 
          e.team,         
          count(distinct p.acco_id) as vip_count,
          count(distinct case when p.current_status = 'ACTIVE' then p.acco_id end) as eligible_vip_count,
          case when count(distinct p.acco_id) >= 270 THEN '270+ Cohort'
              else '<270 Cohort' 
          end as cohort_size
      from eligible_customers p
      left join fbg_analytics.vip.vip_employee_mapping e
          on e.name = p.vip_host
      group by p.vip_host, e.host_type, e.external_title, e.internal_title, e.focus, e.team
  ),
  
  -- select *
  -- from host_assignment
  -- order by 8 desc
  -- --27
  
  status_changes AS (
      SELECT id AS acco_id,
          CONVERT_TIMEZONE('America/Toronto', modified)::TIMESTAMP AS valid_from,
          status,
          LAG(status) OVER (PARTITION BY id ORDER BY CONVERT_TIMEZONE('America/Toronto', modified)) AS prev_status
      FROM fbg_source.osb_source.accounts_audits
      WHERE test = 0
          and date(modified) >= '2026-01-01' 
      QUALIFY status != prev_status OR prev_status IS NULL
  ),
  
  contest_status as (
      SELECT acco_id,
          valid_from,
          COALESCE(LEAD(valid_from) OVER (PARTITION BY acco_id ORDER BY valid_from), '9999-01-01'::TIMESTAMP) AS valid_to,
          status,
          prev_status
      FROM status_changes
      QUALIFY DATE_TRUNC('SECOND', valid_to) <> DATE_TRUNC('SECOND', valid_from)
      ORDER BY valid_to DESC
  ),
  
  contest_bets as (
      select distinct
          a.account_id as acco_id, 
          date(a.wager_settlement_time_alk) as wager_settlement_date,
          a.wager_id,
          case when a.total_cash_stake_by_legs > 0 then wager_id else null end as cash_bet,
          CASE WHEN a.non_boosted_bet_price < 2 THEN (-100 / (a.non_boosted_bet_price-1))
               ELSE (a.non_boosted_bet_price-1) * 100
               END AS american_odds,
          sum(a.total_cash_stake_by_legs) as cash_handle,
          sum(a.total_ggr_by_legs) as cash_ggr, 
          sum(a.expected_cash_ggr_by_legs) as cash_eggr
      from fbg_analytics_engineering.trading.trading_sportsbook_mart a
      join fbg_analytics_engineering.customers.customer_mart b
           on a.account_id = b.acco_id
      where 1=1
          and ((date(a.wager_settlement_time_alk) >= '2026-03-19' and date(a.wager_settlement_time_alk) <= '2026-03-22') 
                  or (date(a.wager_settlement_time_alk) >= '2026-03-26' and date(a.wager_settlement_time_alk) <= '2026-03-29')) 
          and a.is_test_wager = 0
      group by all
      having 
          CASE WHEN a.non_boosted_bet_price < 2 THEN (-100 / (a.non_boosted_bet_price-1))
              ELSE (a.non_boosted_bet_price-1) * 100
              END >= -300 --limit to bets placed with -300 or more
      order by date(a.wager_settlement_time_alk)
  ),
  
  -- select *
  -- from contest_bets
  -- where acco_id = '830323'
  
  days_eligible_for_points AS (
      SELECT 
          a.acco_id,
          a.wager_settlement_date,
          sum(a.cash_handle) total_eligible_cash_handle,
          count(a.wager_id) total_eligible_bets,
          count(a.cash_bet) as total_eligible_cash_bets,
          sum(a.cash_ggr) as cash_ggr, 
          sum(a.cash_eggr) as cash_eggr,
          cs.status as bet_status
      FROM contest_bets a
      join eligible_customers c
          on a.acco_id = c.acco_id
      left join contest_status cs
          on a.acco_id = cs.acco_id
          and a.wager_settlement_date between cs.valid_from and cs.valid_to
      group by all
      having sum(a.cash_handle) >= 150 --Limit to where OSB cash handle > 150 within day
      order by a.wager_settlement_date
  ),
  
  -- select *
  -- from days_eligible_for_points
  -- where acco_id = '830323'
  -- --13991
  
  weekend_bet_days AS (
      select 
          c.acco_id,
          c.contest_start_status,
          c.current_status,
          p.bet_status,
          count(distinct case when p.wager_settlement_date >= '2026-03-19' and p.wager_settlement_date <= '2026-03-22' then p.wager_settlement_date end) AS weekend_1_bet_days,
          count(distinct case when p.wager_settlement_date >= '2026-03-26' and p.wager_settlement_date <= '2026-03-29' then p.wager_settlement_date end) AS weekend_2_bet_days, 
          p.total_eligible_cash_handle,
          p.total_eligible_bets,
          p.total_eligible_cash_bets,
          p.cash_ggr,
          p.cash_eggr
      FROM eligible_customers c
      left join days_eligible_for_points p
      on c.acco_id = p.acco_id
      GROUP BY all
  ),
  
  -- select *
  -- from weekend_bet_days
  -- --15959
  
  points_earned AS (
      select acco_id,
          sum(weekend_1_bet_days) as weekend_1_bet_days,
          case
              when max(bet_status) = 'ACTIVE' and sum(weekend_1_bet_days) < 3 then sum(weekend_1_bet_days) * 1
              when max(bet_status) = 'ACTIVE' and sum(weekend_1_bet_days) = 3 then sum(weekend_1_bet_days) * 2
              when max(bet_status) = 'ACTIVE' and sum(weekend_1_bet_days) = 4 then sum(weekend_1_bet_days) * 3
              else 0
          end as weekend_1_points,
          sum(weekend_2_bet_days) as weekend_2_bet_days,
          case
              when max(bet_status) = 'ACTIVE' and sum(weekend_2_bet_days) < 3 then sum(weekend_2_bet_days) * 1
              when max(bet_status) = 'ACTIVE' and sum(weekend_2_bet_days) = 3 then sum(weekend_2_bet_days) * 2
              when max(bet_status) = 'ACTIVE' and sum(weekend_2_bet_days) = 4 then sum(weekend_2_bet_days) * 3
              else 0
          end as weekend_2_points,
          sum(total_eligible_cash_handle) as total_eligible_cash_handle,
          sum(total_eligible_bets) as total_eligible_bets,
          sum(total_eligible_cash_bets) as total_eligible_cash_bets,
          sum(cash_ggr) as cash_ggr,
          sum(cash_eggr) as cash_eggr
      from weekend_bet_days
      group by all
  ),
  
  -- select *
  -- from points_earned
  -- where acco_id = '2084809'
  
  weekly_summary as (
      select 
          h.cohort_size,
          h.vip_host,
          h.vip_count,
          h.eligible_vip_count,
          sum(p.weekend_1_points) as total_weekend_1_points,
          sum(p.weekend_2_points) as total_weekend_2_points,
          (sum(p.weekend_1_points) + sum(p.weekend_2_points)) as total_points,
          (h.vip_count * 24) as total_possible_points,
          (sum(p.weekend_1_points) + sum(p.weekend_2_points))/(h.vip_count * 24) as percentage_to_target
      from eligible_customers c
      join host_assignment h
          on c.vip_host = h.vip_host
      join points_earned p
          on p.acco_id = c.acco_id
      group by h.cohort_size, h.vip_host, h.vip_count, h.eligible_vip_count
      order by eligible_vip_count desc
  ),
  
  reactivation_weekly_summary as (
      select 
          h.vip_host,
          h.cohort_size,
          count(distinct c.acco_id) as users_eligible_for_activation,
          sum(p.weekend_2_points) as total_weekend_2_points,
          count(distinct c.acco_id) * 12 as total_wk2_possible_points,
          sum(p.weekend_2_points)/(count(distinct c.acco_id) * 12) as wk2_reactivation_percentage
      from eligible_customers c
      join host_assignment h
          on c.vip_host = h.vip_host
      join points_earned p
          on p.acco_id = c.acco_id
      where p.weekend_1_points = 0
      group by h.cohort_size, h.vip_host, h.eligible_vip_count
      order by eligible_vip_count desc
  ),
  
  -- select *
  -- from reactivation_weekly_summary
  
  cbb_flag as (
      select a.account_id, count(distinct wager_id) 
      from fbg_analytics_engineering.trading.trading_sportsbook_mart a
      join fbg_analytics_engineering.customers.customer_mart b
          on a.account_id = b.acco_id 
      where date(a.wager_placed_time_alk) >= '2026-01-01'
      and a.is_test_wager = 0
      and (b.is_casino_vip = 1 or b.is_vip = 1) 
      and b.is_test_account = 0
      and leg_sport_category = 'NCAA Basketball'
      group by a.account_id
  ),
  
  user_details as (
      select 
          h.cohort_size,
          c.vip_host,
          c.acco_id,
          c.contest_start_status,
          c.current_status,
          v.product_preference,
          case when cbb.account_id is not null then 1 else 0 end as ncaa_basketball_flag,
          p.weekend_1_bet_days,
          p.weekend_1_points,
          p.weekend_2_bet_days,
          p.weekend_2_points,
          p.total_eligible_cash_handle as total_contest_cash_handle,
          p.total_eligible_bets as total_contest_osb_bets,
          p.total_eligible_cash_bets as total_contest_osb_cash_bets,
          p.cash_ggr as total_contest_osb_cash_ggr,
          p.cash_eggr as total_contest_osb_cash_eggr
          --sum(case when cvp.date >= '2026-03-19' then cvp.osb_total_bets else 0 end) as total_contest_osb_bets,
          --sum(case when cvp.date >= '2026-03-19' then cvp.osb_cash_bets else 0 end) as total_contest_osb_cash_bets,
          --sum(case when cvp.date >= '2026-03-19' then cvp.osb_cash_handle else 0 end) as total_contest_cash_handle,
          -- sum(case when cvp.date >= '2026-03-19' then cvp.osb_cash_eggr else 0 end) as total_contest_osb_cash_eggr,
          -- sum(case when cvp.date >= '2026-03-19' then cvp.osb_cash_ggr else 0 end) as total_contest_osb_cash_ggr
      from eligible_customers c
      left join host_assignment h
          on c.vip_host = h.vip_host
      left join FBG_ANALYTICS.VIP.VIP_USER_INFO v
          on c.acco_id = v.acco_id
      left join fbg_analytics.product_and_customer.customer_variable_profit cvp
          on cvp.acco_id = c.acco_id
      left join points_earned p
          on p.acco_id = c.acco_id
      left join cbb_flag cbb
          on cbb.account_id = c.acco_id
      group by all
  ),
  
  -- select *
  -- from user_details
  -- where acco_id = '5234018'
  -- --6789
  
  leaderboard as (
      select * from (
          select 
              *,
              row_number() over (partition by cohort_size order by percentage_to_target desc) as rank
          from weekly_summary
      )
      where rank <= 5
  ),
  
  reactivation_leaderboard as (
      select *
      from reactivation_weekly_summary
      order by wk2_reactivation_percentage desc
  )
  
  --Summary tab: Weekly Leaders
  -- select *
  -- from leaderboard
  
  --Summary tab: Weekly Summary
  -- select *
  -- from weekly_summary
  
  --User Details tab
   select *
   from user_details
  
  --Reactivation Dashboard tab
  -- select *
  -- from reactivation_leaderboard
) "Custom SQL Query"
