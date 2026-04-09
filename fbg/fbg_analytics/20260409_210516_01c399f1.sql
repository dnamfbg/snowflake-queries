-- Query ID: 01c399f1-0212-67a8-24dd-0703193110cb
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SER_L_WH
-- Executed: 2026-04-09T21:05:16.232000+00:00
-- Elapsed: 70754ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTIVE_LATER" AS "ACTIVE_LATER",
  "Custom SQL Query"."ACTIVE_WITHIN_12" AS "ACTIVE_WITHIN_12",
  "Custom SQL Query"."CASH_BETS" AS "CASH_BETS",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."CASUAL_HANDLE" AS "CASUAL_HANDLE",
  "Custom SQL Query"."CLOSING_EV_TW" AS "CLOSING_EV_TW",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."EV_CLOSE" AS "EV_CLOSE",
  "Custom SQL Query"."EV_TRADING_WIN" AS "EV_TRADING_WIN",
  "Custom SQL Query"."EXPECTED_BOOST_COST" AS "EXPECTED_BOOST_COST",
  "Custom SQL Query"."EXPECTED_TRADING_WIN" AS "EXPECTED_TRADING_WIN",
  "Custom SQL Query"."FIRST_BET" AS "FIRST_BET",
  "Custom SQL Query"."FREE_BETS" AS "FREE_BETS",
  "Custom SQL Query"."FREE_HANDLE" AS "FREE_HANDLE",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."HOURS" AS "HOURS",
  "Custom SQL Query"."LAST_BET" AS "LAST_BET",
  "Custom SQL Query"."LEG_MARKET_TYPE" AS "LEG_MARKET_TYPE",
  "Custom SQL Query"."LIVE_BET_LATER" AS "LIVE_BET_LATER",
  "Custom SQL Query"."LIVE_WITHIN_12" AS "LIVE_WITHIN_12",
  "Custom SQL Query"."MARKET_DATE" AS "MARKET_DATE",
  "Custom SQL Query"."MEDIAN_ODDS" AS "MEDIAN_ODDS",
  "Custom SQL Query"."MEDIAN_UNBOOSTED_ODDS" AS "MEDIAN_UNBOOSTED_ODDS",
  "Custom SQL Query"."MULTI_BET_LATER" AS "MULTI_BET_LATER",
  "Custom SQL Query"."MULTI_WITHIN_12" AS "MULTI_WITHIN_12",
  "Custom SQL Query"."OTHER_HANDLE" AS "OTHER_HANDLE",
  "Custom SQL Query"."OVERALL_HANDLE" AS "OVERALL_HANDLE",
  "Custom SQL Query"."PROB" AS "PROB",
  "Custom SQL Query"."RESTRICTED_HANDLE" AS "RESTRICTED_HANDLE",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SELECTION_ID" AS "SELECTION_ID",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."TOP_TIER_GOLDEN_SUPERFAN_HANDLE" AS "TOP_TIER_GOLDEN_SUPERFAN_HANDLE",
  "Custom SQL Query"."TOTAL_BETS" AS "TOTAL_BETS",
  "Custom SQL Query"."TRADING_WIN" AS "TRADING_WIN",
  "Custom SQL Query"."UNIQUES" AS "UNIQUES",
  "Custom SQL Query"."VIP_HANDLE" AS "VIP_HANDLE",
  "Custom SQL Query"."XGGR" AS "XGGR"
FROM (
  with First_Daily_Boost as
  (select 
  account_id,
  selection_id,
  min(WAGER_PLACED_TIME_EST) as First_Bet
  from fbg_analytics_engineering.trading.trading_sportsbook_mart
  where lower(leg_sport_category) like '%oost'
  and event_name not ilike '%Boosters%'
  and wager_status = 'SETTLED'
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
  
  Same_Day as 
  (select 
  F.account_id,
  F.selection_id,
  max(case when B.total_cash_stake_by_legs > 0 and (lower(leg_sport_category) not like '%oost' or lower(leg_sport_category) is null) then 1 else 0 end) as Cash_Active_Later_Day,
  max(case when B.account_id is not null and (lower(leg_sport_category) not like '%oost' or lower(leg_sport_category) is null) then 1 else 0 end) as Active_Later_Day,
  max(case when B.IS_LIVE_BET_LEG = 'TRUE' then 1 else 0 end) as Live_Bet_Later_Day,
  max(case when B.NUMBER_OF_LINES_BY_WAGER > 1 then 1 else 0 end) as Multi_Bet_Later_Day
  from First_Daily_Boost F
  LEFT JOIN fbg_analytics_engineering.trading.trading_sportsbook_mart B on F.account_id = B.account_id and B.WAGER_PLACED_TIME_EST > F.First_Bet and date(B.WAGER_PLACED_TIME_EST) = date(F.First_Bet) and wager_status = 'SETTLED' and wager_channel = 'INTERNET'
  group by all
  ),
  
  
  Within_12 as 
  (select 
  F.account_id,
  F.selection_id,
  max(case when B.total_cash_stake_by_legs > 0 and (lower(leg_sport_category) not like '%oost' or lower(leg_sport_category) is null) then 1 else 0 end) as Cash_Active_Within_12,
  max(case when B.account_id is not null and (lower(leg_sport_category) not like '%oost' or lower(leg_sport_category) is null) then 1 else 0 end) as Active_Within_12,
  max(case when B.IS_LIVE_BET_LEG = 'TRUE' then 1 else 0 end) as Live_Bet_Within_12,
  max(case when B.NUMBER_OF_LINES_BY_WAGER > 1 then 1 else 0 end) as Multi_Bet_Within_12
  from First_Daily_Boost F
  LEFT JOIN fbg_analytics_engineering.trading.trading_sportsbook_mart B on F.account_id = B.account_id and B.WAGER_PLACED_TIME_EST > F.First_Bet and B.WAGER_PLACED_TIME_EST < F.First_Bet + INTERVAL '12 HOURS' and wager_status = 'SETTLED' and wager_channel = 'INTERNET'
  group by all
  ),
  
  
  
  OfferDetails as 
  (select 
  B.selection_id,
  avg(case when selection_id in ('373418122','373408141') then -0.0486 else EV.EV_Close end) as EV_Close,
  max(WAGER_PLACED_TIME_EST) as Last_Bet,
  min(WAGER_PLACED_TIME_EST) as First_Bet,
  date(mode(LEG_EVENT_TIME_EST)) as Market_Date,
  -- date(First_Bet) as Market_Date,
  greatest(timediff(min,min(WAGER_PLACED_TIME_EST),max(WAGER_PLACED_TIME_EST))/60,1) as Hours,
  median(total_price_by_wager) as Median_Odds,
  median(non_boosted_bet_price) as Median_Unboosted_Odds,
  (1-avg(case when selection_id in ('373418122','373408141') then -0.0486 else EV.EV_Close end))/Median_Odds as Prob
  
  from fbg_analytics_engineering.trading.trading_sportsbook_mart B 
  LEFT JOIN EV on EV.market_id = B.market_ID and EV.event_id = B.event_id
  where lower(leg_sport_category) like '%oost'
  and LEG_MARKET_TYPE <> 'DARTS:FT:REACTBOOST'
  and b.event_name not ilike '%Boosters%'
  and wager_status = 'SETTLED'
  and wager_channel = 'INTERNET'
  group by all
  )
  
  select 
  B.leg_selection as Selection,
  B.LEG_MARKET_TYPE,
  B.selection_id,
  vbc.trading_segment_group as Current_Value_Band,
  b.WAGER_STATE as state,
  OD.Last_Bet,
  OD.First_Bet,
  OD.Market_Date,
  -- OD.EV_Close,
  -- length(OD.EV_Close),
  cast(OD.EV_Close as decimal(5,4)) as EV_Close,
  OD.Hours,
  OD.Median_Odds,
  OD.Median_Unboosted_Odds,
  OD.Prob,
  (OD.Median_Odds - OD.Median_Unboosted_Odds)*OD.Prob*sum(total_cash_stake_by_legs) as Expected_Boost_Cost,
  1-((1-cast(OD.EV_Close as decimal(5,4)))/OD.Median_Odds)*OD.Median_Unboosted_Odds as EV_Trading_win,
  sum(total_cash_stake_by_legs) as Cash_Handle,
  sum(total_non_cash_stake_by_legs) as Free_Handle,
  sum(total_cash_stake_by_legs) + sum(total_non_cash_stake_by_legs) as Overall_Handle,
  sum(trading_win) as TRADING_WIN,
  sum(total_cash_stake_by_legs) - sum(total_cash_wager_payout_by_legs) as GGR,
  sum(expected_trading_win_by_legs) as EXPECTED_TRADING_WIN,
  sum(EV_Trading_win*total_cash_stake_by_legs) as Closing_EV_TW,
  sum(EV_close*total_cash_stake_by_legs) as xGGR,
  sum(case when Current_Value_Band = 'Restricted' then total_cash_stake_by_legs + total_non_cash_stake_by_legs else 0 end) as Restricted_Handle,
  sum(case when Current_Value_Band ='VIP' then total_cash_stake_by_legs + total_non_cash_stake_by_legs else 0 end) as VIP_Handle,
  sum(case when Current_Value_Band = 'Top Tier & Golden Superfan' then total_cash_stake_by_legs + total_non_cash_stake_by_legs else 0 end) as Top_Tier_Golden_Superfan_Handle,
  sum(case when Current_Value_Band = 'Casual' then total_cash_stake_by_legs + total_non_cash_stake_by_legs else 0 end) as Casual_Handle,
  sum(case when Current_Value_Band = 'Other' then total_cash_stake_by_legs + total_non_cash_stake_by_legs else 0 end) as Other_Handle,
  sum(1/NUMBER_OF_LINES_BY_WAGER) as Total_Bets,
  sum(Case when is_free_Bet_wager = 'FALSE' then 1/NUMBER_OF_LINES_BY_WAGER else 0 end) as Cash_Bets,
  sum(Case when is_free_Bet_wager = 'TRUE' then 1/NUMBER_OF_LINES_BY_WAGER else 0 end) as Free_Bets,
  -- Total_Bets/Hours as Bets_Per_Hour,
  -- Overall_Handle/Total_Bets as Avg_Bet_Size,
  count(distinct B.account_id) as Uniques,
  count(distinct case when SD.Active_Later_Day = 1 then SD.account_id end) as Active_Later,
  count(distinct case when SD.Live_Bet_Later_Day = 1 then SD.account_id end) as Live_Bet_Later,
  count(distinct case when SD.Multi_Bet_Later_Day = 1 then SD.account_id end) as Multi_Bet_Later,
  count(distinct case when W.Active_Within_12 = 1 then W.account_id end) as Active_Within_12,
  count(distinct case when W.Live_Bet_Within_12 = 1 then W.account_id end) as Live_Within_12,
  count(distinct case when W.Multi_Bet_Within_12 = 1 then W.account_id end) as Multi_Within_12
  
  from fbg_analytics_engineering.trading.trading_sportsbook_mart B 
  LEFT JOIN Same_Day SD on B.account_id = SD.account_id and B.selection_id = SD.selection_id
  LEFT JOIN Within_12 W on B.account_id = W.account_id and B.selection_id = W.selection_id
  LEFT JOIN FBG_ANALYTICS.TRADING.value_bands_current as vbc on vbc.acco_id = b.account_id
  LEFT JOIN OfferDetails OD on OD.selection_id = B.selection_id
  where lower(leg_sport_category) like '%oost'
  and LEG_MARKET_TYPE <> 'DARTS:FT:REACTBOOST'
  and b.event_name not ilike '%Boosters%'
  and wager_status = 'SETTLED'
  and wager_channel = 'INTERNET'
  group by all
  order by OD.First_Bet desc
) "Custom SQL Query"
