-- Query ID: 01c399dd-0212-6cb9-24dd-0703192c678f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TRADING_M_WH
-- Executed: 2026-04-09T20:45:38.810000+00:00
-- Elapsed: 372ms
-- Environment: FBG

SELECT AVG("Custom SQL Query"."CUSTOMERS") AS "avg:CUSTOMERS:ok",
  AVG("Custom SQL Query"."HANDLE") AS "avg:HANDLE:ok",
  AVG("Custom SQL Query"."PARLAY_CUSTOMERS") AS "avg:PARLAY_CUSTOMERS:ok",
  AVG("Custom SQL Query"."PARLAY_HANDLE") AS "avg:PARLAY_HANDLE:ok",
  AVG("Custom SQL Query"."SGP_CUSTOMERS") AS "avg:SGP_CUSTOMERS:ok",
  AVG("Custom SQL Query"."SGP_HANDLE") AS "avg:SGP_HANDLE:ok",
  AVG("Custom SQL Query"."SINGLES_CUSTOMERS") AS "avg:SINGLES_CUSTOMERS:ok",
  AVG("Custom SQL Query"."SINGLES_HANDLE") AS "avg:SINGLES_HANDLE:ok"
FROM (
  WITH
  
  field_book_stage_ AS (
  
      SELECT
          node_id,
          market_id,
          instrument_id,
          MAX(selection) player,
          SUM(total_stake/num_lines) cash_handle,
          SUM(CASE WHEN odds_boost_bonus = TRUE THEN total_stake/num_lines else 0 end) cash_handle_pbt,
          SUM(total_stake/num_lines*total_price) cash_potential_payout_ggr,
          SUM(total_stake/num_lines*CASE WHEN odds_boost_bonus = TRUE THEN COALESCE(price_at_placement, total_price) else total_price END) cash_potential_payout_tw
  
      FROM
          FBG_SOURCE.OSB_SOURCE.BETS
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.BET_PARTS
          on ((Bets.ID = BET_PARTS.BET_ID))
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS
          on (Bets.Acco_Id = Accounts.Id)
      WHERE
      
      channel = 'INTERNET'
      AND
      DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) >= '2024-01-01'
      AND
      accounts.test = 0
      AND
      bets.status = 'ACCEPTED'
      AND
      market_id IN (554465339)
      and
      CASE
          WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
          ELSE bets.FREE_BET
      END = FALSE
      AND
      bet_type = 'SINGLE'
  
  
  GROUP BY
  ALL
  
  
  
  ),
  
  
  field_book AS (
  
      SELECT
          *,
          SUM(cash_handle) over (partition by market_id) - cash_potential_payout_ggr AS cash_liability_ggr,
          SUM(cash_handle) over (partition by market_id) - cash_potential_payout_tw AS cash_liability_tw,
          cash_potential_payout_tw/NULLIF(cash_handle, 0) avg_price
      FROM
          field_book_stage_
  
  ),
  
  overall_numbers AS (
  
      SELECT
          node_id,
          COUNT(DISTINCT bets.acco_id) customers,
          SUM(total_stake/num_lines) handle,
          COUNT(DISTINCT CASE WHEN bet_type = 'SINGLE' THEN bet_id END) singles_customers,
          SUM(CASE WHEN bet_type = 'SINGLE' THEN total_stake/num_lines ELSE 0 END) singles_handle,
          COUNT(DISTINCT CASE WHEN bet_type <> 'SINGLE' AND build_a_bet = FALSE THEN bet_id END) parlay_customers,
          SUM(CASE WHEN bet_type <> 'SINGLE' AND build_a_bet = FALSE THEN total_stake/num_lines else 0 END) parlay_handle,
          COUNT(DISTINCT CASE WHEN bet_type <> 'SINGLE' AND build_a_bet = TRUE THEN bet_id END) sgp_customers,
          SUM(CASE WHEN bet_type <> 'SINGLE' AND build_a_bet = TRUE THEN total_stake/num_lines else 0 END) sgp_handle
          
  
      FROM
          FBG_SOURCE.OSB_SOURCE.BETS
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.BET_PARTS
          on ((Bets.ID = BET_PARTS.BET_ID))
      INNER JOIN
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS
          on (Bets.Acco_Id = Accounts.Id)
      WHERE
      
      channel = 'INTERNET'
      AND
      DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) >= '2024-01-01'
      AND
      accounts.test = 0
      AND
      bets.status <> 'VOID'
      AND
      node_id IN (4134841)
      and
      CASE
          WHEN bets.fancash_stake_amount > 0 AND bets.FREE_BET = FALSE THEN TRUE
          ELSE bets.FREE_BET
      END = FALSE
  
  
  GROUP BY
  ALL
  
  )
  
  SELECT
      field_book.*,
      MAX(customers) AS customers,
      MAX(handle) AS handle,
      MAX(singles_customers) AS singles_customers,
      MAX(singles_handle) AS singles_handle, 
      MAX(parlay_customers) AS parlay_customers,
      MAX(parlay_handle) AS parlay_handle,
      MAX(sgp_customers) AS sgp_customers,
      MAX(sgp_handle) AS sgp_handle
  
  FROM
      field_book
  INNER JOIN
      overall_numbers 
      ON field_book.node_id = overall_numbers.node_id
  
  GROUP BY
      ALL
) "Custom SQL Query"
HAVING (COUNT(1) > 0)
