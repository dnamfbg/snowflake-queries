-- Query ID: 01c39a29-0212-644a-24dd-0703193e0aa3
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:01:09.209000+00:00
-- Elapsed: 7744ms
-- Environment: FBG

SELECT "Custom SQL Query"."BET_MODIFIED_DATE_STAGE" AS "BET_MODIFIED_DATE_STAGE",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."COMPETITION" AS "COMPETITION",
  "Custom SQL Query"."EVENT_DATE_ET" AS "EVENT_DATE_ET",
  "Custom SQL Query"."EVENT_END_TIME_ET" AS "EVENT_END_TIME_ET",
  "Custom SQL Query"."EVENT_ID" AS "EVENT_ID",
  "Custom SQL Query"."EVENT_NAME" AS "EVENT_NAME",
  "Custom SQL Query"."EVENT_TIME_ET" AS "EVENT_TIME_ET",
  "Custom SQL Query"."MANUAL_MARKET" AS "MANUAL_MARKET",
  "Custom SQL Query"."MARKET_GROUP_1" AS "MARKET_GROUP_1",
  "Custom SQL Query"."MARKET_GROUP_2" AS "MARKET_GROUP_2",
  "Custom SQL Query"."MARKET_ID" AS "MARKET_ID",
  "Custom SQL Query"."MARKET_NAME" AS "MARKET_NAME",
  "Custom SQL Query"."MARKET_SETTLEMENT_TIME" AS "MARKET_SETTLEMENT_TIME",
  "Custom SQL Query"."MARKET_UNSETTLED_HANDLE" AS "MARKET_UNSETTLED_HANDLE",
  "Custom SQL Query"."MAX_BET_MODIFIED_DATE" AS "MAX_BET_MODIFIED_DATE",
  "Custom SQL Query"."MRKT_TYPE" AS "MRKT_TYPE",
  "Custom SQL Query"."PROVIDER" AS "PROVIDER",
  "Custom SQL Query"."SELECTION_ID" AS "SELECTION_ID",
  "Custom SQL Query"."SELECTION_NAME" AS "SELECTION_NAME",
  "Custom SQL Query"."SIX_BOX_MARKET" AS "SIX_BOX_MARKET",
  "Custom SQL Query"."SPORT" AS "SPORT",
  "Custom SQL Query"."SPORT_STAGE" AS "SPORT_STAGE",
  "Custom SQL Query"."UNSETTLED_HANDLE" AS "UNSETTLED_HANDLE",
  "Custom SQL Query"."UNSETTLED_VIP_HANDLE" AS "UNSETTLED_VIP_HANDLE",
  "Custom SQL Query"."VIP_ACTIVE_ON_MARKET" AS "VIP_ACTIVE_ON_MARKET",
  "Custom SQL Query"."VIP_CASH_HANDLE" AS "VIP_CASH_HANDLE"
FROM (
  with
  
  
  
  
  stage_1
  
  as
  
  (
  
  
  
  select
  
  
  selection_id,
  max(LEG_SELECTION) selection_name,
  max(market_id) market_id,
  max(event_id) event_id,
  max(wager_modified_time_utc) bet_modified_date_stage,
  max(LEG_MARKET) market_name,
  max(event_league) competition,
  --max(case when result_type = 'NOT_SET' then 1 else 0 end) result_not_set,
  max(case when event_Feed_provider is null then 1 when lower(event_Feed_provider) like '%ats%' then 1 else 0 end) manual_market,
  max(case when lower(account_value_Band_as_of_placement) = 'vip' and leg_result_type = 'NOT_SET' then 1 else 0 end) vip_active_on_market, 
  max(LEG_MARKET_TYPE) mrkt_type,
  max(market_tier_one_group) market_group_1,
  max(market_tier_two_group) market_group_2,
  max(case when leg_market_type In ('AMERICAN_FOOTBALL:FTOT:ML','ICE_HOCKEY:FTOT:ML','BASEBALL:FTOT:ML','BASKETBALL:FTOT:ML') then 'Money Line'
       when leg_market_type In ('AMERICAN_FOOTBALL:FTOT:SPRD','BASKETBALL:FTOT:SPRD','BASEBALL:FTOT:SPRD','ICE_HOCKEY:FTOT:SPRD') then 'Spread'
       when leg_market_type In ('AMERICAN_FOOTBALL:FTOT:OU','BASKETBALL:FTOT:OU','BASEBALL:FTOT:OU','ICE_HOCKEY:FTOT:OU') then 'Totals' else 'Other' end) six_box_market,
  max(event_name) event_name,
  min(date(LEG_EVENT_TIME_EST)) event_date_et,
  min(LEG_EVENT_TIME_EST) event_time_et,
  min(event_close_time_utc) event_end_time_et,
  min(CONVERT_TIMEZONE('UTC','America/New_York', dateadd('ms',(IFNULL(nullif((SPLIT_PART(SPLIT_PART (m.attributes, 'firstResultedTime=', 2), ';', 1)::varchar), ''),0)),'1970-01-01'))) market_settlement_time,
  max(INITCAP(replace(leg_sport_category,'_',' '))) sport_stage,
  max(case when event_Feed_provider is null then 'Manual' when lower(event_Feed_provider) like '%ats%' then 'Manual' else event_Feed_provider end) provider, -- updatelogic
  sum(total_cash_stake_by_legs) cash_handle,
  sum(case when lower(account_value_Band_as_of_placement) = 'vip' then total_cash_stake_by_legs else 0 end) vip_cash_handle,
  sum(case when leg_result_type = 'NOT_SET' then total_cash_stake_by_legs else 0 end) unsettled_handle,
  sum(case when leg_result_type = 'NOT_SET' and lower(account_value_Band_as_of_placement) = 'vip' then total_cash_stake_by_legs else 0 end) unsettled_vip_handle
  
  
  from
  
  
  fbg_analytics_engineering.trading.trading_sportsbook_mart sb
                             
                             LEFT JOIN fbg_source.osb_source.markets m ON sb.market_id = m.id
  
  
                             
  where
  
  
  WAGER_STATUS <> 'REJECTED'
  and
  leg_result_type = 'NOT_SET'
  and
  wager_status = 'ACCEPTED'
  and
  IS_TEST_wager = FALSE
  
  GROUP BY
  
  ALL
  
  
  
  ),
  
  
  stage_2 as
  
  (
  
  select
  
  
  stage_1.*,
  case when sport_stage IN ('Mlb','Nfl','Nba','Wnba','Nhl','Mma','Cfb') then upper(sport_stage) when sport_stage = 'Ncaa Basketball' then 'NCAA Basketball' else sport_stage end sport,
  max(bet_modified_date_stage) over (partition by 1) max_bet_modified_date,
  sum(unsettled_handle) over (partition by market_id) market_unsettled_handle
  
  from
  
  stage_1 
  
  
  )
  
  select
  
  *
  
  from 
  
  stage_2
) "Custom SQL Query"
