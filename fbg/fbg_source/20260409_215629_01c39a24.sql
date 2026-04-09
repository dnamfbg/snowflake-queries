-- Query ID: 01c39a24-0212-67a9-24dd-0703193cf05b
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:56:29.812000+00:00
-- Elapsed: 40483ms
-- Environment: FBG

SELECT "Custom SQL Query"."AMELCO_ID" AS "AMELCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."ONLINE_ACCT_ID" AS "ONLINE_ACCT_ID",
  "Custom SQL Query"."RETAIL_CARD_ID" AS "RETAIL_CARD_ID",
  "Custom SQL Query"."STATE" AS "STATE"
FROM (
  with bet_req as 
  
  (SELECT
  b.id as bet_id,
  b.retail_card_id as retail_card_id,
  aa.id as online_acct_id,
  aa.ref1 as amelco_id,
  rv.name as retail_venue,
  bp.event, 
  SUM(b.total_stake/b.num_lines) as handle
  
  FROM FBG_SOURCE.OSB_SOURCE.BETS b 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS aa ON b.retail_card_id = aa.ref3
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.RETAIL_VENUES rv ON a.retail_venue_id = rv.id
  
  WHERE b.channel = 'RETAIL'
  AND CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) >= '2025-02-04'
  AND CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) <= '2025-02-09'
  AND b.build_a_bet = 'TRUE' -- SGP
  AND b.test = 0  -- No Test
  AND b.num_lines >= 3 -- 3+ Legs
  AND b.retail_card_id IS NOT NULL -- Used a Retail Card
  AND aa.id IS NOT NULL -- has an online account
  AND bp.node_id = 1942000 -- Super Bowl Event ID
  AND rv.name NOT LIKE '%OCEAN%' AND rv.name NOT LIKE '%MAZATAL%' AND rv.name NOT LIKE '%SHELTON%' -- exclude venues
  
  GROUP BY ALL),
  
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
  
  WHERE BONUS_CAMPAIGN_ID = 60280
  AND STATE != 'AVAILABLE'
  
  GROUP BY ALL)
  
  SELECT 
  br.online_acct_id, 
  br.retail_card_id, 
  br.amelco_id,
  br.bet_id, 
  o.state
  
  FROM bet_req br
  INNER JOIN optins o ON br.online_acct_id = o.acco_id
  
  GROUP BY ALL
) "Custom SQL Query"
