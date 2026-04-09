-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e70e7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T22:01:40.039000+00:00
-- Elapsed: 60607ms
-- Environment: FBG

SELECT "Custom SQL Query"."AMELCO_ID" AS "AMELCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."DECIMAL_ODDS" AS "DECIMAL_ODDS",
  "Custom SQL Query"."ELIGIBLE_LEG_COUNT" AS "ELIGIBLE_LEG_COUNT",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."JURISDICTION_CODE" AS "JURISDICTION_CODE",
  "Custom SQL Query"."NCAA_TOURNEY_ROUND" AS "NCAA_TOURNEY_ROUND",
  "Custom SQL Query"."ONLINE_ACCT_ID" AS "ONLINE_ACCT_ID",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME" AS "PLACED_TIME",
  "Custom SQL Query"."RETAIL_CARD_ID" AS "RETAIL_CARD_ID",
  "Custom SQL Query"."RETAIL_VENUE" AS "RETAIL_VENUE",
  "Custom SQL Query"."SETTLEMENT_TIME" AS "SETTLEMENT_TIME",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."TOTAL_LEGS" AS "TOTAL_LEGS"
FROM (
  with bet_req as 
  
  (SELECT * 
  
  FROM 
  
  (SELECT
  b.id as bet_id,
  TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time)) as placed_time,
  TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', b.settlement_time)) as settlement_time,
  -- TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', bp.event_time)) as event_date_est,
  CASE WHEN TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', bp.event_time)) IN ('2026-03-19', '2026-03-20') then 'Round 1'
       WHEN TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', bp.event_time)) IN ('2026-03-21', '2026-03-22') then 'Round 2'
       ELSE 'Other' END AS NCAA_Tourney_Round,
  b.status as bet_status,
  b.num_lines as total_legs, 
  COUNT(DISTINCT bp.id) as eligible_leg_count,
  b.retail_card_id as retail_card_id,
  aa.id as online_acct_id,
  aa.ref1 as amelco_id,
  rv.name as retail_venue,
  b.free_bet, 
  j.jurisdiction_code,
  --bp.event,
  --DAYNAME(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time)), 
  --CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time),
  ROUND(b.total_price, 2) as decimal_odds,
  SUM(b.total_stake/b.num_lines) as handle, 
  SUM(b.payout/b.num_lines) as payout
  
  FROM FBG_SOURCE.OSB_SOURCE.BETS b 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS aa ON b.retail_card_id = aa.ref3
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.RETAIL_VENUES rv ON a.retail_venue_id = rv.id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j ON b.jurisdictions_id = j.id
  
  WHERE b.channel = 'RETAIL'
  AND b.status IN ('ACCEPTED', 'SETTLED')
  AND TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time)) >= '2026-03-16'
  AND TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time)) <= '2026-03-22'
  AND TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', bp.event_time)) >= '2026-03-19'
  AND TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', bp.event_time)) <= '2026-03-22'
  AND b.test = 0  -- No Test
  AND b.num_lines >= 3 -- 3+ Legs
  AND b.retail_card_id IS NOT NULL -- Used a Retail Card
  AND aa.id IS NOT NULL -- has an online account
  AND bp.comp LIKE ('%NCAA%') -- NCAA Bet
  AND bp.sport = 'BASKETBALL'
  AND b.total_price >= 3.5 -- Greater than +250
  
  --AND DAYNAME(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time)) = 'Sat' -- Saturday Games Only
  AND j.jurisdiction_code IN ('AZ', 'CT', 'IA', 'IL', 'MD', 'MO', 'OH', 'VA') -- only certain states
  
  GROUP BY ALL) abc
  
  WHERE abc.total_legs = abc.eligible_leg_count -- Total Bet Legs = Number of Eligible Bet Legs
  ),
  
  bet_users as 
  
  (SELECT DISTINCT 
  retail_card_id, 
  online_acct_id, 
  amelco_id, 
  bet_id
  
  FROM bet_req),
  
  optins as 
  
  (SELECT DISTINCT acco_id, state, bonus_campaign_id
  
  FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES
  
  WHERE BONUS_CAMPAIGN_ID IN (1085239) -- Promo Campaign IDs
  AND STATE != 'AVAILABLE'
  
  GROUP BY ALL)
  
  SELECT 
  br.*,
  o.state
  
  FROM bet_req br
  INNER JOIN optins o ON br.online_acct_id = o.acco_id
  
  WHERE handle >= 9.98
  
  GROUP BY ALL
) "Custom SQL Query"
