-- Query ID: 01c39a30-0212-6e7d-24dd-0703193f99eb
-- Database: FBG_ANALYTICS_DEV
-- Schema: unknown
-- Warehouse: BI_SER_L_WH_PROD
-- Executed: 2026-04-09T22:08:16.497000+00:00
-- Elapsed: 131279ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTUAL_HANDLE" AS "ACTUAL_HANDLE",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."FORECAST_HANDLE" AS "FORECAST_HANDLE",
  "Custom SQL Query"."SEASON_STAGE" AS "SEASON_STAGE",
  "Custom SQL Query"."SET_DATE" AS "SET_DATE",
  "Custom SQL Query"."TRADING_WIN" AS "TRADING_WIN",
  "Custom SQL Query"."TW_FORECAST" AS "TW_FORECAST",
  "Custom SQL Query"."WEEK" AS "WEEK"
FROM (
  //weekly handle
  
  
  with
  
  transformed_forecast
  
  as
  
  (
  
  SELECT
  n.Season_stage, 
  n.WEEK, 
  n.day, 
  date,
  MAX(NFL_HANDLE) forecast_handle,
  MAX(NFL_TW) TW_FORECAST
  FROM
  
    fbg_analytics_Dev.Andrew_mcmahon.FORECASTS FC
    LEFT JOIN fbg_analytics_Dev.Andrew_mcmahon.NFL_Fixtures2526 n ON  TO_DATE(FC.date) = TO_DATE(n.event_time_alk)
    
   
  
    GROUP BY
  
    ALL
  
    ),
  
  
  date_settled
  
  as
  
  (with
  
  was_price
  
  as
  
  (
  
  select
  
  instrument_id,
  max(non_boosted_price) non_boosted_price
  
  from
  (
  
  
  select 
  *, 
  position('(was',lower(selection)) abc, 
  replace(substr(selection, abc+5,6),' ','') american_odds, 
  substr(american_odds, 1,1) neg_pos, 
  case when abc = 0 then '0' when neg_pos not IN ('-','+') then '0' else replace((substr(american_odds, 2,4)),')','')
  end
  odds_value,
  to_double(case when lower(odds_value) like '%x%' then '0' else odds_value end) odds_value_2,
  case when odds_value_2 = 0 then price
       when neg_pos = '+' then ((1/100)*odds_value)+1
       when neg_pos = '-' then (1-(100/(odds_value*-1)))
       end non_boosted_price
  
  
       from
       (
  
  select
  
  instrument_id,
  max(selection) selection,
  min(case when original_price is not null then original_price else price end) price
  
  
  
  
  from
  FBG_SOURCE.OSB_SOURCE.BETS 
  inner join FBG_SOURCE.OSB_SOURCE.BET_PARTS on ((Bets.ID = BET_PARTS.BET_ID))
  
  where
  
  channel = 'INTERNET'
  and
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) >= '2023-01-01'
  and
  CASE
      WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
      ELSE bets.FREE_BET
  END = FALSE
  and
  odds_boost_bonus = FALSE
  and
  case when comp ILIKE '%boost%' then 1 
               when Market ILIKE '%boost%' then 1  
               when Mrkt_Type ILIKE '%boost%' THEN 1 else 0 end = 1
  
  GROUP BY
  
  ALL
  
  
  )
  
  )
  GROUP BY 
  
  ALL
  
  )
  
  
  select
  
  
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) set_date,
  sum(case when free_bet = FALSE then total_stake/num_lines else 0 end) actual_handle,
  
  
  
  sum(case when FREE_BET = FALSE THEN total_stake/num_lines-payout/num_lines else 0 end)
  +
  sum(case when FREE_BET = FALSE and payout > 0 and payout >= total_stake and case when nvl(odds_boost_bonus_winnings,0) > 0 then 1 when odds_boost_bonus = TRUE then 1 else 0 end = 1 and result <> 4 then (((payout/total_stake)-((((parse_json(data):Bonus:oddsBoost:boostPercentage)/100)+(payout/total_stake))/(((parse_json(data):Bonus:oddsBoost:boostPercentage)/100)+1)))*total_stake)/num_lines else 0 end)
  +
  sum(case when FREE_BET = FALSE and payout > 0 and result <> 4 and non_boosted_price is not null and non_boosted_price < case when original_price is not null then original_price else price end and case when original_price is null then price else original_price end <= price then (((case when original_price is not null then original_price else price end)-non_boosted_price)*(total_stake/num_lines))*(payout/(total_stake*case when free_bet = TRUE then total_price-1 else total_price end)) else 0 end) trading_win
  
  from
  FBG_SOURCE.OSB_SOURCE.BETS 
  inner join FBG_SOURCE.OSB_SOURCE.BET_PARTS on ((Bets.ID = BET_PARTS.BET_ID))
  inner join FBG_SOURCE.OSB_SOURCE.ACCOUNTS on (Bets.Acco_Id = Accounts.Id)
  left outer join was_price on (bet_parts.instrument_id = was_price.instrument_id)
  left outer join fbg_source.osb_source.bonus_campaigns on (bets.bonus_campaign_id = bonus_campaigns.id)
  
  
  WHERE
  
  accounts.test = 0
  and
  lower(bet_parts.sport) = 'american_football'
  and
  case when lower(bet_parts.comp) like '%nfl%' then 1 
       when lower(bet_parts.comp) like '%ncaa%' then 2 else 0 end = 1
  and
  bets.status NOT IN ('REJECTED','VOID')
  and
  DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) >= '2024-09-04'
  and
  CASE
      WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
      ELSE bets.FREE_BET
  END = FALSE
  and
  bets.channel = 'INTERNET'
  
  
  
  
  GROUP  BY 
  
  ALL
  
  
  
  
  
  
  )
  
  select
  
  
  * from 
  
  transformed_forecast left outer join date_settled on transformed_forecast.date = date_settled.set_DATE
  WHERE SEASON_sTAGE IS NOT NULL
  ORDER BY DATE ASC
) "Custom SQL Query"
