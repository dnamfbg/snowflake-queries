-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e1ed7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_M_PROD
-- Executed: 2026-04-09T22:01:29.175000+00:00
-- Elapsed: 4248ms
-- Environment: FBG

SELECT "Custom SQL Query"."ID" AS "ID",
  "Custom SQL Query"."NUM_LINES" AS "NUM_LINES",
  "Custom SQL Query"."PARTS_NOT_SET" AS "PARTS_NOT_SET",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."WALLET_SETTLEMENT_STATUS_ID" AS "WALLET_SETTLEMENT_STATUS_ID"
FROM (
  SELECT
  b.id,
  b.num_lines,
  b.status, 
  b.wallet_settlement_status_id,
  count(distinct case when bp.result_type = 'NOT_SET' then bp.id end) parts_not_set
  
  FROM FBG_SOURCE.OSB_SOURCE.BETS b
  INNER JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
  INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON b.acco_id = a.id
  
  
  WHERE b.status IN ('ACCEPTED') -- Bets in an Accepted State
  AND b.placed_time >= '2023-09-01' -- Date Filter so it doesn't pull forever
  AND a.test = 0
  AND b.wallet_settlement_status_id != 3
  AND b.wallet_settlement_status_id != 4
  
  
  
  
  GROUP BY ALL
  
  HAVING 
  
  count(distinct case when bp.result_type = 'NOT_SET' then bp.id end) = 0
) "Custom SQL Query"
