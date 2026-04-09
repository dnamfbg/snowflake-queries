-- Query ID: 01c39a0d-0212-644a-24dd-07031937b717
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:33:30.998000+00:00
-- Elapsed: 109476ms
-- Environment: FBG

WITH 
--Universe of customers; exclude casino and referral. Categorize the offer type
users_temp as (
    select
        acco_id
        , date(sportsbook_ftu_date_alk) ftu_date
        , registration_state
        , acquisition_channel
        , case when acquisition_bonus_name = 'Bet $5, Get $200' then acquisition_bonus_name else 'Other Offer' end as suo_name
        , w2_retained
        , pred_gp_18mo_total_final
    from fbg_analytics.product_and_customer.acquisition_customer_mart
        where ftu_date >= '2026-03-01'
            and is_test_account = 0
            and is_kiosk = 0
            and acquisition_channel != 'Referral'
            and first_product = 'SBK'
)

--Sportsbook promo ledger. Capture bonus used and winnings
, ledger_temp as (
    select
        a.acco_id
        , ftu_date
        , registration_state
        , acquisition_channel
        , suo_name
        , w2_retained
        , pred_gp_18mo_total_final
        -- , "Bonus Code"
        , promo_type
        , sum(case when transaction = 'bonus used' then amount else 0 end) as bonus_used
        , sum(case when transaction = 'bonus winnings' then amount else 0 end) as bonus_winnings
        -- a.*
    FROM users_temp a
    LEFT JOIN  FBG_P13N.PROMO_SILVER_TABLE.PROMOTIONS_LEDGER_FINAL u
            ON u.acco_id = a.acco_id
            and "Bonus Category" = 'Acquisition'
            and transaction IN ('bonus winnings', 'bonus used')
            AND ("SubCategory" not in ('Refer a Friend','RaF','RAF') or "SubCategory" is NULL)
            and "SubCategory" not ilike '%Refer_A_Friend%'
            and (promo_type != 'boost_market' or promo_type is null)
    group by all
)

-- , ledger_temp_oc as (
--     select
--         a.acco_id
--         , ftu_date
--         , registration_state
--         , suo_name
--         -- , "Bonus Code"
--         , promo_type
--         , sum(case when transaction = 'bonus used' then amount else 0 end) as bonus_used
--         , sum(case when transaction = 'bonus winnings' then amount else 0 end) as bonus_winnings
--         -- a.*
--     FROM users_temp a
--     LEFT JOIN  fbg_analytics.product_and_customer.CASINO_PROMOTIONS_LEDGER u
--             ON u.acco_id = a.acco_id
--             and "Bonus Category" = 'Acquisition'
--             and transaction IN ('bonus winnings', 'bonus used')
--             -- AND ("SubCategory" not in ('Refer a Friend','RaF','RAF') or "SubCategory" is NULL)
--             -- and "SubCategory" not ilike '%Refer_A_Friend%'
--             and (promo_type != 'boost_market' or promo_type is null)
--     group by all
-- )

-- select * from ledger_temp_oc

--categorize usage and winnings by promo type
, ledger_temp2 as (
    select 
        acco_id
        , ftu_date
        , registration_state
        , acquisition_channel
        , suo_name
        , w2_retained
        , pred_gp_18mo_total_final
        , sum(case when promo_type in ('fancash','bonus_bet','profit_boost') then bonus_used else 0 end) as bonus_used_fbg
        , sum(case when promo_type = 'fancash_commerce' then bonus_used else 0 end) as bonus_used_comm
        , sum(case when promo_type in ('fancash_topps','fancash_collect') then bonus_used else 0 end) as bonus_used_topps_collect
        , sum(case when promo_type not in ('fancash', 'bonus_bet','profit_boost','fancash_commerce','fancash_topps','fancash_collect') then bonus_used else 0 end) as bonus_used_other

        , sum(case when promo_type in ('fancash','bonus_bet','profit_boost') then bonus_winnings else 0 end) as bonus_winnings_fbg
        , sum(case when promo_type = 'fancash_commerce' then bonus_winnings else 0 end) as bonus_winnings_comm
        , sum(case when promo_type in ('fancash_topps','fancash_collect') then bonus_winnings else 0 end) as bonus_winnings_topps_collect
        , sum(case when promo_type not in ('fancash', 'bonus_bet','profit_boost','fancash_commerce','fancash_topps','fancash_collect') then bonus_winnings else 0 end) as bonus_winnings_other
        
        -- , sum(case when promo_type = 'fancash' then bonus_winnings else 0 end) as bonus_winnings_fc
        -- , sum(case when promo_type = 'fancash_commerce' then bonus_winnings else 0 end) as bonus_winnings_comm
        -- , sum(case when promo_type not in ('fancash', 'fancash_commerce') then bonus_winnings else 0 end) as bonus_winnings_other
    from ledger_temp
    group by all
)

--First 7 days activity
, od_temp as (
select s.acco_id,
    -- ftu_date,
count(distinct case when (cash_handle > 0 or oc_handle > 0) 
        and bus_date <= dateadd('day',6,s.ftu_date) then bus_date end) as cash_active_days_f7d,
    sum(case when bus_date <= dateadd('day',6,s.ftu_date) then deposit_amount else 0 end) as deposit_amount_f7d
from users_temp s
left join fbg_analytics.product_and_customer.account_revenue_summary_daily a 
    on a.acco_id = s.acco_id 
    and a.bus_date < dateadd('day', 28, s.ftu_date)
group by all
)

, sportsbook_activity as (
    select distinct 
        a.acco_id
        -- date(a.sportsbook_ftu_date_alk) ftu_date_sbk,
        , count(distinct case when total_cash_stake_by_wager > 0
            AND date(wager_placed_time_alk) <= dateadd('day', 6, ftu_date)
            then wager_id else null end) as sbk_cash_bets_7d
        , sum(case when date(wager_placed_time_alk) <= dateadd('day', 2, ftu_date)
            then total_cash_stake_by_legs else 0 end) as sbk_handle_3d
        , sum(case when date(wager_placed_time_alk) <= dateadd('day', 6, ftu_date)
            then total_cash_stake_by_legs else 0 end) as sbk_handle_7d
    from users_temp a
    inner join fbg_analytics_engineering.trading.trading_sportsbook_mart  t 
        on a.acco_id = t.account_id
        and wager_status NOT IN ('REJECTED','VOID')
        and wager_channel = 'INTERNET'
    where a.ftu_date is not null
        and ftu_date < DATE(CURRENT_DATE())
    group by all
)

-- select * from fbg_analytics_engineering.trading.trading_sportsbook_mart 
-- limit 1000


--Create several flags based on bonus usage and activity
, commerce_activity as (
select 
    a.*
    , b.cash_active_days_f7d
    , b.deposit_amount_f7d
    , c.sbk_cash_bets_7d
    , c.sbk_handle_7d
    , c.sbk_handle_3d
    , case when cash_active_days_f7d <= 1 then 1 else 0 end as one_and_done_7d
    , case when bonus_used_comm >= 150 then 1 else 0 end as commerce_first_flag
    , case when bonus_used_comm + bonus_used_other >= 150 then 1 else 0 end as commerce_other_first_flag
    , case when bonus_used_comm >= 150 and bonus_used_fbg = 0 then 1 else 0 end as commerce_only_flag
    , case when bonus_winnings_topps_collect >= 150 and bonus_used_fbg = 0 then 1 else 0 end as topps_collect_only_flag
    , case when (bonus_used_comm + bonus_winnings_topps_collect) >= 150 and bonus_used_fbg = 0 then 1 else 0 end as commerce_topps_collect_only_flag
    , case when c.sbk_cash_bets_7d <= 1 then 1 else 0 end as one_and_done_sbk_cash_bets_7d
    
from ledger_temp2 a
left join od_temp b 
    on a.acco_id = b.acco_id
left join sportsbook_activity c
    on a.acco_id = c.acco_id
)

--Sum values 
select 
    ftu_date
    , suo_name
    , acquisition_channel
    ,  case when acquisition_channel in ('Affiliate', 'App Networks', 'Social', 'Search') then 'Performance'
            when acquisition_channel in ('Organic & Other') then 'Organic'
            when acquisition_channel in ('Referral') then 'RAF'
            else 'Other'
        end as acq_channel
    -- , commerce_first_flag
    -- , commerce_other_first_flag
    , commerce_only_flag
    , topps_collect_only_flag
    , commerce_topps_collect_only_flag
    , count(distinct acco_id) ftu_count
    , one_and_done_7d
    , one_and_done_sbk_cash_bets_7d
    , sum(cash_active_days_f7d) cash_active_days_f7d
    , sum(deposit_amount_f7d) deposit_amount_f7d
    , sum(sbk_handle_7d) sbk_handle_7d
    , sum(w2_retained) w2_retained
    , sum(pred_gp_18mo_total_final) pred_gp_18mo_total_final

    , sum(bonus_used_fbg) bonus_used_fbg
    , sum(bonus_used_comm) bonus_used_comm
    , sum(bonus_used_topps_collect) bonus_used_topps_collect
    , sum(bonus_used_other) bonus_used_other
    , sum(bonus_used_fbg + bonus_used_comm + bonus_used_topps_collect + bonus_used_other) bonus_used_total
    , sum(bonus_winnings_fbg) bonus_winnings_fbg
    , sum(bonus_winnings_comm) bonus_winnings_comm
    , sum(bonus_winnings_topps_collect) bonus_winnings_topps_collect
    , sum(bonus_winnings_other) bonus_winnings_other
    , sum(bonus_winnings_fbg + bonus_winnings_comm + bonus_winnings_topps_collect + bonus_winnings_other) bonus_winnings_total
    , sum(one_and_done_7d) one_and_done_7d_sum
    , sum(sbk_cash_bets_7d) sbk_cash_bets_7d
    , sum(sbk_handle_3d) sbk_handle_3d

from commerce_activity
where ftu_date is not null
group by all
order by 1, 2, 3
;
