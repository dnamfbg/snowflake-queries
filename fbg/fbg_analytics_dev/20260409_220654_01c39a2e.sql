-- Query ID: 01c39a2e-0212-67a9-24dd-0703193f4763
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:06:54.485000+00:00
-- Elapsed: 110517ms
-- Environment: FBG

with awards as
(
---- rewards unpacked
select
ats_account_id as acco_id,
bonus_campaign as bc,
date(created_date) as dt,
sum(fancash_amount) as awarded_amount
FROM FBG_SOURCE.FANX_MONGODB.FANCASH
where bonus_campaign in('1004794','1004793','221031','220955','154338','154337','154336','153594','172028')
group by all

union 

----- punch card
select
ats_account_id as acco_id,
bonus_campaign as bc,
date(created_date) as dt,
sum(fancash_amount) as awarded_amount
FROM FBG_SOURCE.FANX_MONGODB.FANCASH
where bonus_campaign = '1010364'
group by all

union 

---- deposit match
select
ats_account_id as acco_id,
bonus_campaign as bc,
date(created_date) as dt,
--- x .6 from Zack
sum(fancash_amount) *.6 as awarded_amount
FROM FBG_SOURCE.FANX_MONGODB.FANCASH
where bonus_campaign in ('1027079','1028359')
group by all

union

select
account_id as acco_id,
promotion_id as bc,
max(wager_settlement_time_alk) as dt,
max(nvl(WAGER_BOOST_TOKEN_PAYOUT,0)) as awarded_amount
from FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART
where promotion_id in (
    SELECT distinct id as bonus_id    
    FROM fbg_source.osb_source.bonus_campaigns where PARSE_JSON(data):Bonus:bonusCode::STRING  ilike '%el_50pbt%' 
    and  PARSE_JSON(data):Bonus:oddsBoost:boostPercentage::FLOAT = 50.0
)
and date(wager_settlement_time_alk) >= '2025-11-01'
group by all

union 
-- Other Campaigns
select
acco_id,
bonus_campaign_id as bc,
date(trans_date) as dt,
sum(amount) as awarded_amount
FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS
where
 bonus_campaign_id in
    (
    SELECT distinct bonus_campaign_id
    from fbg_analytics.product_and_customer.bonus_categories
    where subcategory = 'Early Life' 
    ) or bonus_campaign_id in (1031002, 1040090)
group by all
)



,vt as (

with acq_temp as (
select acm.acco_id, sportsbook_ftu_date_alk
from fbg_analytics.product_and_customer.acquisition_customer_mart acm
inner join awards on awards.acco_id = acm.acco_id
)


,handle_temp as 
(SELECT
    account_id AS acco_id,
    date(sportsbook_ftu_date_alk) ftu_date,
    count( distinct date(wager_placed_time_alk)) AS active_days,
    sum(total_cash_stake_by_legs) as cash_stake,
    count(distinct wager_id) as num_cash_bets    
  FROM
    acq_temp a
    left join fbg_analytics_engineering.trading.trading_sportsbook_mart t
        on t.account_id = a.acco_id 
        and t.wager_placed_time_alk >= a.sportsbook_ftu_date_alk  
        and date(t.wager_placed_time_alk) < dateadd('day',7,date(a.sportsbook_ftu_date_alk)) --7 days or less
  WHERE
    total_cash_stake_by_wager > 0
    and wager_channel = 'INTERNET'
    and wager_status in ('SETTLED', 'ACCEPTED')
  GROUP BY ALL
)

,value_tier as (
select 
a.acco_id,
     case when cash_stake  >=250 then 'high potential'
        else 'low potential'
        end as value_tier
from handle_temp a
left join acq_temp b
    on a.acco_id = b.acco_id
group by all)

select
acco_id, value_tier
from value_tier
)


select 
awards.acco_id,
p.id,
vt.value_tier,
awards.dt,
awards.awarded_amount,
awards.bc,
PARSE_JSON(data):Bonus:bonusCode::STRING  AS bonus_code,
PARSE_JSON(data):Bonus:name::STRING  AS bonus_name
from awards
left join vt on vt.acco_id = awards.acco_id
left join fbg_source.osb_source.bonus_campaigns p on p.id = awards.bc
WHERE DT > '2026-03-01'
AND BONUS_NAME LIKE '%OC%'
