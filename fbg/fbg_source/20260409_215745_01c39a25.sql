-- Query ID: 01c39a25-0212-67a8-24dd-0703193d2727
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:57:45.173000+00:00
-- Elapsed: 21030ms
-- Environment: FBG

SELECT "Custom SQL Query"."AMELCO_ID" AS "AMELCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."DECIMAL_ODDS" AS "DECIMAL_ODDS",
  "Custom SQL Query"."ELIGIBLE_LEG_COUNT" AS "ELIGIBLE_LEG_COUNT",
  "Custom SQL Query"."FREE_BET" AS "FREE_BET",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."JURISDICTION_CODE" AS "JURISDICTION_CODE",
  "Custom SQL Query"."ONLINE_ACCT_ID" AS "ONLINE_ACCT_ID",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."PLACED_TIME" AS "PLACED_TIME",
  "Custom SQL Query"."RETAIL_CARD_ID" AS "RETAIL_CARD_ID",
  "Custom SQL Query"."RETAIL_VENUE" AS "RETAIL_VENUE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."TOTAL_LEGS" AS "TOTAL_LEGS"
FROM (
  with bet_req as 
  
  (SELECT * 
  
  FROM 
  
  (SELECT
  b.id as bet_id,
  CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) as placed_time,
  b.status as bet_status,
  b.num_lines as total_legs, 
  COUNT(DISTINCT bp.id) as eligible_leg_count,
  --bp.comp,
  --bp.event,
  b.retail_card_id as retail_card_id,
  aa.id as online_acct_id,
  aa.ref1 as amelco_id,
  rv.name as retail_venue,
  b.free_bet, 
  j.jurisdiction_code,
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
  AND CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) >= '2025-06-01'
  AND CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) <= '2025-06-30'
  AND b.test = 0  -- No Test
  AND b.num_lines >= 3 -- 4+ Legs
  AND b.retail_card_id IS NOT NULL -- Used a Retail Card
  AND aa.id IS NOT NULL -- has an online account
  AND bp.comp LIKE ('NBA%')
  AND bp.sport = 'BASKETBALL'
  AND ((j.jurisdiction_code IN ('OH', 'IA', 'IL', 'MD', 'VA', 'CT') AND b.total_price >= 4) 
      OR (j.jurisdiction_code IN ('AZ') AND b.total_price >= 2)) -- only certain states and price requirements
  
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
  
  (SELECT DISTINCT acco_id, state
  
  FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES
  
  WHERE BONUS_CAMPAIGN_ID IN (104563, 104564) -- Promo Campaign ID for NBA Finals
  AND STATE != 'AVAILABLE'
  
  GROUP BY ALL)
  
  SELECT 
  br.*,
  o.state
  
  FROM bet_req br
  INNER JOIN optins o ON br.online_acct_id = o.acco_id
  
  GROUP BY ALL
) "Custom SQL Query"
