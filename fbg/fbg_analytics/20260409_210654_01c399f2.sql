-- Query ID: 01c399f2-0212-6cb9-24dd-07031931517f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SER_L_WH
-- Executed: 2026-04-09T21:06:54.609000+00:00
-- Elapsed: 153908ms
-- Environment: FBG

SELECT "Custom SQL Query"."BOOST_CASH_USERS" AS "BOOST_CASH_USERS",
  "Custom SQL Query"."BOOST_TOTAL_USERS" AS "BOOST_TOTAL_USERS",
  "Custom SQL Query"."BOOST_USERS_WITH_LIVE_BET" AS "BOOST_USERS_WITH_LIVE_BET",
  "Custom SQL Query"."BOOST_USERS_WITH_MULTI_BET" AS "BOOST_USERS_WITH_MULTI_BET",
  "Custom SQL Query"."BOOST_USERS_WITH_NON_BOOST" AS "BOOST_USERS_WITH_NON_BOOST",
  "Custom SQL Query"."CASH_ACTIVES" AS "CASH_ACTIVES",
  "Custom SQL Query"."CASH_BETS" AS "CASH_BETS",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."EV_TRADING_WIN" AS "EV_TRADING_WIN",
  "Custom SQL Query"."EXPECTED_GGR" AS "EXPECTED_GGR",
  "Custom SQL Query"."FIRST_TIME_BOOSTERS" AS "FIRST_TIME_BOOSTERS",
  "Custom SQL Query"."FREE_BETS" AS "FREE_BETS",
  "Custom SQL Query"."FREE_HANDLE" AS "FREE_HANDLE",
  "Custom SQL Query"."FTUS" AS "FTUS",
  "Custom SQL Query"."FTU_BOOST_USERS" AS "FTU_BOOST_USERS",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."MONTHLY_CASH_BETS" AS "MONTHLY_CASH_BETS",
  "Custom SQL Query"."MONTHLY_CASH_HANDLE" AS "MONTHLY_CASH_HANDLE",
  "Custom SQL Query"."MONTHLY_TOTAL_BETS" AS "MONTHLY_TOTAL_BETS",
  "Custom SQL Query"."MONTHLY_TOTAL_HANDLE" AS "MONTHLY_TOTAL_HANDLE",
  "Custom SQL Query"."PLACED_MONTH_ET" AS "PLACED_MONTH_ET",
  "Custom SQL Query"."RESTRICTED_HANDLE" AS "RESTRICTED_HANDLE",
  "Custom SQL Query"."TOTAL_ACTIVES" AS "TOTAL_ACTIVES",
  "Custom SQL Query"."TOTAL_BETS" AS "TOTAL_BETS",
  "Custom SQL Query"."TOTAL_HANDLE" AS "TOTAL_HANDLE",
  "Custom SQL Query"."TRADING_WIN" AS "TRADING_WIN",
  "Custom SQL Query"."XTRADING_WIN" AS "XTRADING_WIN"
FROM (
  with First_Boost as
  (select 
  account_id,
  min(case when lower(leg_sport_category) like '%oost' and event_name not ilike '%Boosters%' then WAGER_PLACED_TIME_EST end) as First_Boost,
  date(trunc(min(WAGER_PLACED_TIME_EST),'month')) as First_Bet_month
  from fbg_analytics_engineering.trading.trading_sportsbook_mart
  where wager_status in ('SETTLED')
  and wager_channel = 'INTERNET'
  group by all
  ),
  
  EV as
  (SELECT 
  airtable_json,
  parse_json(airtable_json):"fields":"Boost Title" as title,
  parse_json(airtable_json):createdTime as create_time,
  parse_json(airtable_json):"fields":"Event ID" as EVENT_ID,
  parse_json(airtable_json):"fields":"Market ID" as Market_ID,
  parse_json(airtable_json):"fields":"EV - Close" as EV_Close
  FROM FBG_SOURCE.AIRTABLE.ODDSBOOSTS 
  order by create_time asc
  ),
  
  OfferDetails as 
  (select 
  B.selection_id,
  median(TOTAL_PRICE_BY_WAGER) as Median_Odds,
  median(non_boosted_bet_price) as Median_Unboosted_Odds,
  1-((1-cast(avg(EV_Close) as decimal(5,4)))/Median_Odds)*Median_Unboosted_Odds as EV_Trading_win,
  cast(avg(EV_Close) as decimal(5,4)) as EV_GGR
  
  from fbg_analytics_engineering.trading.trading_sportsbook_mart B 
  LEFT JOIN EV on EV.market_id = B.market_ID and ev.event_id = b.event_id
  where lower(leg_sport_category) like '%oost'
  and leg_market_type <> 'DARTS:FT:REACTBOOST'
  and event_name not ilike '%Boosters%'
  and wager_status = 'SETTLED'
  and wager_channel = 'INTERNET'
  group by all
  ),
  
  monthly_Users as
  (select 
  B.account_id,
  vbc.trading_segment_group,
  date(trunc(b.WAGER_PLACED_TIME_EST,'month')) as Placed_month_ET,
  sum(case when b.is_Free_bet_wager = 'FALSE' then 1 else 0 end) as monthly_Cash_Bets,
  count(b.account_id) as monthly_Total_Bets,
  sum(b.total_cash_stake_by_legs) as monthly_Cash_Handle,
  sum(b.total_cash_stake_by_legs) + sum(total_non_cash_stake_by_legs) as monthly_Total_Handle,
  count(distinct b.account_id) as Active,
  count(distinct case when b.is_Free_bet_wager = 'FALSE' then b.account_id end) as Cash_Active,
  count(distinct case when FB.First_Bet_month = date(trunc(B.WAGER_PLACED_TIME_EST,'month')) then b.account_id end) as FTU,
  count(distinct case when b.IS_LIVE_BET_LEG = 'TRUE' then b.account_id end) as Live_Active,
  count(distinct case when b.NUMBER_OF_LINES_BY_WAGER > 1 then b.account_id end) as Multi_Active,
  count(distinct case when (lower(leg_sport_category) not like '%oost' or lower(leg_sport_category) is null) then b.account_id end) as Non_Boost_Active
  from fbg_analytics_engineering.trading.trading_sportsbook_mart b
  LEFT JOIN FBG_ANALYTICS.TRADING.value_bands_current as vbc on vbc.acco_id = b.account_id
  LEFT JOIN First_Boost FB on FB.account_id = b.account_id 
  where wager_status in ('SETTLED')
  and wager_channel = 'INTERNET'
  and b.WAGER_PLACED_TIME_EST < current_date
  group by all
  ),
  
  monthly_Boosts as
  (select
  B.account_id,
  date(trunc(WAGER_PLACED_TIME_EST,'month')) as Placed_month_ET,
  count(distinct b.account_id) as Boost_Active,
  count(distinct case when FB.First_Boost = B.WAGER_PLACED_TIME_EST then b.account_id end) as First_Boost,
  count(distinct case when FB.First_Bet_month = date(trunc(WAGER_PLACED_TIME_EST,'month')) then b.account_id end) as FTU,
  count(distinct case when is_free_bet_wager = 'FALSE' then b.account_id end) as Cash_Boost_Active,
  sum(b.total_cash_stake_by_legs) as Cash_Handle,
  sum(b.total_non_cash_stake_by_legs) as Free_Handle,
  sum(b.total_cash_stake_by_legs) + sum(b.total_non_cash_stake_by_legs) as Overall_Handle,
  sum(b.trading_win) as TRADING_WIN,
  sum(total_cash_stake_by_legs) - sum(total_cash_wager_payout_by_legs) as GGR,
  sum(b.expected_trading_win_by_legs) as xTrading_Win,
  sum(b.total_cash_stake_by_legs*EV_Trading_win) as EV_Trading_Win,
  sum(b.total_cash_stake_by_legs*EV_GGR) as eGGR,
  sum(case when leg_stake_factor < 1 then b.total_cash_stake_by_legs + b.total_non_cash_stake_by_legs else 0 end) Restricted_Handle,
  sum(1/NUMBER_OF_LINES_BY_WAGER) as Total_Bets,
  sum(Case when is_free_bet_wager = 'FALSE' then 1/NUMBER_OF_LINES_BY_WAGER else 0 end) as Cash_Bets,
  sum(Case when is_free_bet_wager = 'TRUE' then 1/NUMBER_OF_LINES_BY_WAGER else 0 end) as Free_Bets
  -- count(distinct case when Non_Boost_Active = 1 then b.account_id end)/Boost_Uniques as Boost_Users_Non_Boosted_Bet,
  -- count(distinct case when Live_Active = 1 then b.account_id end)/Boost_Uniques as Boost_Users_Non_Live_Bet,
  -- count(distinct case when Multi_Active = 1 then b.account_id end)/Boost_Uniques as Boost_Users_Non_Boosted_Bet
  from fbg_analytics_engineering.trading.trading_sportsbook_mart b 
  LEFT JOIN First_Boost FB on FB.account_id = b.account_id 
  LEFT JOIN OfferDetails EV on EV.selection_id = B.selection_id
  -- LEFT JOIN Daily_Users DU on DU.account_id = b.account_id and DU.Placed_Date_ET = date(b.placed_time_et)
  where lower(leg_sport_category) like '%oost'
  and leg_market_type <> 'DARTS:FT:REACTBOOST'
  and event_name not ilike '%Boosters%'
  and wager_status in ('SETTLED')
  and wager_channel = 'INTERNET'
  group by all
  )
  
  select 
  DU.Placed_month_ET,
  trading_segment_group as Current_Value_Band,
  sum(monthly_Cash_Bets) as monthly_Cash_Bets,
  sum(monthly_Total_Bets) as monthly_Total_Bets,
  sum(monthly_Cash_Handle) as monthly_Cash_Handle,
  sum(monthly_Total_Handle) as monthly_Total_Handle,
  sum(Cash_Handle) as Cash_Handle,
  sum(Free_Handle) as Free_Handle,
  sum(Overall_Handle) as Total_Handle,
  sum(Trading_Win) as Trading_Win,
  sum(GGR) as GGR,
  sum(xTrading_Win) as xTrading_Win,
  sum(EV_Trading_Win) as EV_Trading_Win,
  sum(Eggr) as Expected_GGR,
  sum(Restricted_Handle) as Restricted_Handle,
  sum(Total_Bets) as Total_Bets,
  sum(Cash_Bets) as Cash_Bets,
  sum(Free_Bets) as Free_Bets,
  sum(Boost_Active) as Boost_Total_Users,
  sum(Active) as Total_Actives,
  -- Boost_Total_Users/Total_Actives as Daily_Total_Users_Perc,
  sum(Cash_Boost_Active) as Boost_Cash_Users,
  sum(Cash_Active) as Cash_Actives,
  -- Boost_Cash_Users/Cash_Actives as Daily_Cash_Users_Perc,
  sum(DB.First_Boost) as First_Time_Boosters,
  sum(DB.FTU) as FTU_Boost_Users,
  sum(DU.FTU) as FTUs,
  -- FTU_Boost_Users/FTUs as FTUs_Who_Used_Boost_Perc,
  sum(case when Boost_Active = 1 and Non_Boost_Active = 1 then 1 else 0 end) as Boost_Users_With_Non_Boost,
  -- Boost_Users_With_Non_Boost/Boost_Total_Users,
  sum(case when Boost_Active = 1 and Live_Active = 1 then 1 else 0 end) as Boost_Users_With_Live_Bet,
  -- Boost_Users_With_Live_Bet/Boost_Total_Users,
  sum(case when Boost_Active = 1 and Multi_Active = 1 then 1 else 0 end) as Boost_Users_With_Multi_Bet,
  -- Boost_Users_With_Multi_Bet/Boost_Total_Users
  
  FROM monthly_Users DU 
  LEFT JOIN monthly_Boosts DB on DB.account_id = DU.account_id and DB.Placed_month_ET = DU.Placed_month_ET
  group by all
  having sum(Total_Bets) > 0
) "Custom SQL Query"
