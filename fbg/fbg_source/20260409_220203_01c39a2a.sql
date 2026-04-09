-- Query ID: 01c39a2a-0212-67a8-24dd-0703193e38a7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:03.471000+00:00
-- Elapsed: 5934ms
-- Environment: FBG

SELECT "Custom SQL Query"."American Odds" AS "American Odds",
  "Custom SQL Query"."Bet ID" AS "Bet ID",
  "Custom SQL Query"."Bet Placed Time" AS "Bet Placed Time",
  "Custom SQL Query"."Bet Selection" AS "Bet Selection",
  "Custom SQL Query"."Bet Settlement Time AST" AS "Bet Settlement Time AST",
  "Custom SQL Query"."Bet Settlement Time EST" AS "Bet Settlement Time EST",
  "Custom SQL Query"."Bet Type" AS "Bet Type",
  "Custom SQL Query"."Customer ID" AS "Customer ID",
  "Custom SQL Query"."Free Bet" AS "Free Bet",
  "Custom SQL Query"."Handle" AS "Handle",
  "Custom SQL Query"."Number of Legs" AS "Number of Legs",
  "Custom SQL Query"."Payout" AS "Payout",
  "Custom SQL Query"."Result" AS "Result",
  "Custom SQL Query"."State" AS "State",
  "Custom SQL Query"."WALLET_SETTLEMENT_STATUS_ID" AS "WALLET_SETTLEMENT_STATUS_ID"
FROM (
  select 
  a.id AS "Customer ID"
  ,b.id AS "Bet ID"
  ,b.bet_type AS "Bet Type"
  ,b.num_lines AS "Number of Legs"
  ,RTRIM(RTRIM(LISTAGG(DISTINCT CONCAT(bp.Event, ' / ', bp.Market, ' / ',bp.Selection, ' + ', Char(13))) WITHIN GROUP (ORDER BY CONCAT(bp.Event, ' / ', bp.Market, ' / ',bp.Selection, ' + ',Char(13))),Char(13)),' + ') AS "Bet Selection"
  ,j.jurisdiction_code AS "State"
  ,CASE WHEN b.result = 1 THEN 'Win' WHEN b.result = 3 THEN 'Push or Void' WHEN b.result = 4 THEN 'Cashed Out' ELSE 'Loss' END AS "Result"
  ,CONVERT_TIMEZONE('UTC','America/New_York',b.Placed_Time)AS "Bet Placed Time"
  ,CONVERT_TIMEZONE('UTC','America/Anchorage',b.Settlement_Time) AS "Bet Settlement Time AST"
  ,CONVERT_TIMEZONE('UTC','America/New_York',b.Settlement_Time) AS "Bet Settlement Time EST" 
  ,ROUND (CASE WHEN b.Total_Price < 2 THEN (-100 / (b.Total_Price-1)) 
   ELSE (b.Total_Price-1) * 100 END,0) AS "American Odds"
  ,(b.free_bet) AS "Free Bet"  
  ,b.wallet_settlement_status_id
  ,SUM(b.total_stake/b.num_lines) AS "Handle"
  ,SUM(b.payout/b.num_lines) AS "Payout"
  
          
  From FBG_SOURCE.OSB_SOURCE.bets b
  left join FBG_SOURCE.OSB_SOURCE.accounts a on b.acco_id = a.id
  left join FBG_SOURCE.OSB_SOURCE.bet_parts bp on b.id = bp.bet_id
  left join FBG_SOURCE.OSB_SOURCE.jurisdictions j on b.jurisdictions_id = j.id
          
  where a.test = 0
  and wallet_settlement_status_id = 3
  group by all
) "Custom SQL Query"
