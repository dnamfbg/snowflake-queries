-- Query ID: 01c39a2b-0212-644a-24dd-0703193e6fa3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SER_L_WH
-- Executed: 2026-04-09T22:03:22.105000+00:00
-- Elapsed: 16007ms
-- Environment: FBG

SELECT "Custom SQL Query"."COUNT_BETS" AS "COUNT_BETS",
  "Custom SQL Query"."MAIN_LINE" AS "MAIN_LINE",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."TOTAL_BETS" AS "TOTAL_BETS"
FROM (
  WITH main_line AS (
      SELECT
          node_id,
          Market_id,
          mrkt_type,
          event,
          market,
          line,
          COUNT(*) Bets,
          ROW_NUMBER() OVER (PARTITION BY node_id, mrkt_type ORDER BY Bets DESC) AS rank
      FROM fbg_source.osb_source.bets b
          JOIN fbg_source.osb_source.bet_parts ON b.id = bet_parts.bet_id
          JOIN fbg_source.osb_source.accounts ON b.acco_id = accounts.id
          LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa ON b.id = sfsa.bet_id
  
      WHERE accounts.test = 0
        AND b.status <> 'REJECTED'
        AND mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:OU','AMERICAN_FOOTBALL:FTOT:SPRD','AMERICAN_FOOTBALL:FTOT:ML')
        AND node_id = '3668598'
      GROUP BY ALL
      QUALIFY rank = 1
  ),
  
  main_selections AS (
      SELECT
          CASE WHEN m.market_id IS NOT NULL THEN 1 ELSE 0 END AS Main_Line,
          bp.node_id,
          bp.Market_id,
          CASE WHEN bp.mrkt_type = 'AMERICAN_FOOTBALL:FTOT:OU' THEN 'Total'
               WHEN bp.mrkt_type = 'AMERICAN_FOOTBALL:FTOT:SPRD' THEN 'Spread'
               WHEN bp.mrkt_type = 'AMERICAN_FOOTBALL:FTOT:ML' THEN 'Moneyline'
          END AS Market_vague,
          bp.event,
          bp.market,
          bp.selection,
          bp.line,
          jurisdiction_name AS state,
          COUNT(*) Count_Bets
      FROM fbg_source.osb_source.bets b
          JOIN fbg_source.osb_source.bet_parts bp ON b.id = bp.bet_id
          JOIN fbg_source.osb_source.accounts ON b.acco_id = accounts.id
          LEFT JOIN main_line m ON m.market_id = bp.market_id
          INNER JOIN fbg_source.osb_source.jurisdictions ON b.jurisdictions_id = jurisdictions.id
          LEFT OUTER JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts sfsa ON b.id = sfsa.bet_id
  
      WHERE accounts.test = 0
        AND b.status <> 'REJECTED'
        AND bp.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:OU','AMERICAN_FOOTBALL:FTOT:SPRD','AMERICAN_FOOTBALL:FTOT:ML')
        AND bp.node_id = '3668598'
      GROUP BY ALL
  )
  
  SELECT
      Main_line,
      market,
      selection,
      state AS registration_State,
      Count_Bets,
      SUM(Count_Bets) OVER (PARTITION BY market, registration_State) AS Total_Bets
  FROM main_selections
  ORDER BY registration_State, market
) "Custom SQL Query"
