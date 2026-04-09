-- Query ID: 01c399e0-0212-6dbe-24dd-0703192ce80f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:48:19.481000+00:00
-- Elapsed: 11038ms
-- Environment: FBG

with stats as (
select
competitor_A_Name,
competitor_B_Name,
event_league,
event_close_time_alk,
event_name,
event_sport_name,
event_id,
--leg_selection, --keep only for Golf
date(wager_settlement_time_alk) as time,
sum(total_cash_Stake_by_legs) as handle,
sum(case when is_live_bet_leg = TRUE THEN total_cash_Stake_by_legs END) AS live_handle
from 
fbg_analytics_engineering.trading.trading_sportsbook_mart
where
wager_status = 'SETTLED'
and wager_channel = 'INTERNET'
and is_free_bet_wager = FALSE
and is_test_wager = FALSE
AND total_price_by_wager >= 1.2
AND promotion_boost_percentage IS NULL
--and wager_bet_type IN ('SINGLE', 'BETBUILDER')
--AND is_live_bet_leg = TRUE
and date(wager_placed_time_alk) BETWEEN '2026-03-01' AND '2026-04-30'
 --current_date() --'2025-10-30'
AND date(event_start_time_alk) != '2025-12-25'
-- and event_start_time_alk > wager_placed_time_alk
-- AND (event_league ILIKE 'NHL' AND event_sport_name ILIKE '%Hockey%')
-- AND (event_league ILIKE 'NBA%' AND event_sport_name ILIKE '%Basketball%')
--AND (event_league ILIKE 'NBA All Star Game' AND event_sport_name ILIKE '%Basketball%') --All-Star Game
-- AND event_league ILIKE '%NHL' AND event_sport_name ILIKE '%Ice Hockey%' AND event_league NOT ILIKE '%NHL Preaseason%'
-- AND event_league ILIKE '%NFL%' AND event_sport_name ILIKE '%American Football%'
-- AND event_league ILIKE '%MLB%' AND event_sport_name ILIKE '%Baseball%'
-- AND ((event_league ILIKE 'EPL' OR event_league ILIKE '%England Premier League%') AND event_sport_name ILIKE '%SOCCER%')
AND (event_league ILIKE '%UEFA Champions%' AND event_sport_name ILIKE '%SOCCER%')
--AND event_league ILIKE '%WNBA%' AND event_sport_name ILIKE '%Basketball%' --WNBA
-- and event_league IN ('ATP Australian Open', 'ATP Australian Open Doubles') and event_sport_name ilike '%TENNIS%' --TENNIS
--AND event_sport_name = 'GOLF' AND event_league ILIKE '%The Genesis Invitational%' AND date_part(year, wager_placed_time_alk) = 2025
-- AND event_sport_name = 'TENNIS' AND event_league ILIKE '%ATP Dallas, USA Men Singles%' AND event_league NOT ILIKE '%Qualification%'
-- AND event_sport_name = 'TENNIS' AND event_league ILIKE '%ATP Doha, Qatar Men Singles%' AND event_league NOT ILIKE '%Qualification%'
--AND event_sport_name = 'TENNIS' AND event_league IN ('WTA Indian Wells') AND event_league NOT ILIKE '%Qualification%' -- BNP Womens
-- AND event_sport_name = 'TENNIS' AND event_league IN ('ATP Indian Wells, USA Men Singles') AND event_league NOT ILIKE '%Qualification%' -- BNP Mens
-- AND event_sport_name = 'TENNIS' AND event_league IN ('ATP Dubai, UAE Men Singles') AND event_league NOT ILIKE '%Qualification%' -- ATP Dubai
-- AND event_sport_name = 'TENNIS' AND event_league IN ('ATP Dubai, UAE Men Singles','ATP Dallas, USA Men Singles', 'ATP Doha, Qatar Men Singles') AND event_league NOT ILIKE '%Qualification%' -- ATP Dubai

-- AND event_sport_name = 'TENNIS' AND event_league IN ('Australian Open Men Singles', 'ATP Australian Open') //AND event_league NOT ILIKE '%Qualification%' -- Australian Open men's
-- AND event_sport_name = 'TENNIS' AND event_league IN ('ATP Australian Open Asia-Pacific Wildcard playoff', 'ATP Australian Open Qualification') //AND event_league NOT ILIKE '%Qualification%' -- Australian Open men's
-- AND event_sport_name = 'TENNIS' AND event_league IN ('WTA Australian Open Asia-Pacific Wildcard playoff', 'WTA Australian Open Qualification') //AND event_league NOT ILIKE '%Qualification%' -- Australian Open men's

-- AND event_sport_name = 'TENNIS' AND event_league ILIKE ('%ATP Australian Open%') AND event_league NOT ILIKE '%Qualification%' -- Australian Open men's
-- AND event_sport_name = 'TENNIS' AND event_league IN ('Australian Open Women Singles', 'WTA Australian Open') AND event_league NOT ILIKE '%Qualification%' -- Australian Open women's
-- AND event_sport_name = 'TENNIS' AND event_league ILIKE ('%Australian Open Mixed Doubles%') AND event_league NOT ILIKE '%Qualification%' -- Australian Open men's
-- and event_league ilike 'NCAA' and event_sport_name ilike '%BASKETBALL%' --College Basketball
-- and event_league ilike 'NCAAF' and event_sport_name ilike '%American Football%' --American Football
 -- and (event_name ilike '%guardians%' OR event_name ilike '%athletics%')
--and (event_name ilike '%celtics%')

--and leg_market_type = 'AMERICAN_FOOTBALL:FTOT:WSATD'
group by all
having handle >= 20000

)
select
date(event_close_time_alk),
--date_trunc(day, date(event_close_time_alk)) as time_b,
-- time,
sum(handle),
sum(live_handle),
event_name,
event_id,
-- leg_selection,
event_league,
event_sport_name,
competitor_A_Name,
competitor_B_Name,
//avg(handle),
//median(handle)
from 
stats
GROUP BY all
    --event_name, event_id, event_sport_name, event_close_time_alk,event_league, competitor_A_Name, competitor_B_Name
order by 1 ASC;
