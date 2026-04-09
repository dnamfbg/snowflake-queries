-- Query ID: 01c39a26-0212-6e7d-24dd-0703193d65cf
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:58:11.943000+00:00
-- Elapsed: 25090ms
-- Environment: FBG

SELECT "Custom SQL Query"."AMELCO_ID" AS "AMELCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."BET_STATUS" AS "BET_STATUS",
  "Custom SQL Query"."BONUS_WEEK" AS "BONUS_WEEK",
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
  AND CONVERT_TIMEZONE('UTC', 'America/New_York', b.placed_time) >= '2025-09-05'
  AND b.test = 0  -- No Test
  AND b.num_lines >= 3 -- 3+ Legs
  AND b.retail_card_id IS NOT NULL -- Used a Retail Card
  AND aa.id IS NOT NULL -- has an online account
  AND bp.comp LIKE ('%NCAA%')
  AND bp.sport = 'AMERICAN_FOOTBALL'
  AND b.total_price > 2 -- Greater than +100
  AND DAYNAME(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bp.event_time)) = 'Sat' -- Saturday Games Only
  --AND j.jurisdiction_code IN ('OH', 'IA', 'IL', 'MD', 'VA', 'CT') -- only certain states
  
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
  
  WHERE BONUS_CAMPAIGN_ID IN (163823,169719,172154,178735,187856,192254,196064,205684,210212,212168,212169,212170) -- Promo Campaign IDs
  AND STATE != 'AVAILABLE'
  
  GROUP BY ALL)
  
  SELECT 
  br.*,
   CASE WHEN o.bonus_campaign_id = 163823 then 'Sept 6'
        WHEN o.bonus_campaign_id = 169719 then 'Sept 13'
        WHEN o.bonus_campaign_id = 172154 then 'Sept 20'
        WHEN o.bonus_campaign_id = 178735 then 'Sept 27'
        WHEN o.bonus_campaign_id = 187856 then 'Oct 11'
        WHEN o.bonus_campaign_id = 192254 then 'Oct 18'
        WHEN o.bonus_campaign_id = 196064 then 'Oct 25'
        WHEN o.bonus_campaign_id = 205684 then 'Nov 8'
        WHEN o.bonus_campaign_id = 210212 then 'Nov 14/15'
        WHEN o.bonus_campaign_id = 212168 then 'Nov 22'
        WHEN o.bonus_campaign_id = 212169 then 'Nov 29'
        WHEN o.bonus_campaign_id = 212170 then 'Dec 6'
        ELSE 'TBD' end as bonus_week,
  o.state
  
  FROM bet_req br
  INNER JOIN optins o ON br.online_acct_id = o.acco_id
  
  WHERE handle >= 50
  
  GROUP BY ALL
) "Custom SQL Query"
