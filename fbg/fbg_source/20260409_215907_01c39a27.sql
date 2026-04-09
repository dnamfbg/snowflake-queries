-- Query ID: 01c39a27-0212-6e7d-24dd-0703193d6ca3
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:59:07.956000+00:00
-- Elapsed: 12484ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."DATE_EST" AS "DATE_EST",
  "Custom SQL Query"."EVENT" AS "EVENT",
  "Custom SQL Query"."EVENT_DATE" AS "EVENT_DATE",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."NODE_ID" AS "NODE_ID",
  "Custom SQL Query"."RETAIL_CARD_ID" AS "RETAIL_CARD_ID",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."SETTLED_DATE" AS "SETTLED_DATE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."TOTAL_PRICE" AS "TOTAL_PRICE",
  "Custom SQL Query"."TOTAL_STAKE" AS "TOTAL_STAKE"
FROM (
  SELECT 
  b.id as bet_id,
  b.retail_card_id, 
  aa.id as acco_id, 
  TO_DATE(b.placed_time) as date_est,
  TO_DATE(bp.event_time) as event_date, 
  TO_DATE(b.settlement_time) as settled_date,
  rv.name,
  bp.node_id, 
  bp.event, 
  bp.market, 
  bp.selection, 
  --bp.mrkt_type,
  b.status, 
  j.jurisdiction_code as state, 
  b.total_price, 
  b.total_stake
  
  FROM FBG_SOURCE.OSB_SOURCE.BETS b 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j ON b.jurisdictions_id = j.id 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.RETAIL_VENUES rv ON a.retail_venue_id = rv.id 
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS aa ON b.retail_card_id = aa.ref3
  
  WHERE b.status IN ('SETTLED', 'ACCEPTED')
  AND b.placed_time >= '2025-09-01'
  AND b.channel = 'RETAIL'
  AND bp.comp LIKE '%NFL%'
  AND bp.mrkt_type LIKE '%%FTOT:ML%'
  AND b.num_lines = 1
  AND b.total_stake >= 20
  AND b.retail_card_id IS NOT NULL
  AND b.test = 0
) "Custom SQL Query"
