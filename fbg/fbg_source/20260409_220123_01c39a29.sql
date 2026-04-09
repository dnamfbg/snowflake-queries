-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e1dc3
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:01:23.013000+00:00
-- Elapsed: 124469ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."CASINO_ACTIVES" AS "CASINO_ACTIVES",
  "Custom SQL Query"."CASINO_CASH_ACTIVES" AS "CASINO_CASH_ACTIVES",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."ONLY_CAS" AS "ONLY_CAS",
  "Custom SQL Query"."ONLY_CAS_CASH" AS "ONLY_CAS_CASH",
  "Custom SQL Query"."ONLY_OSB" AS "ONLY_OSB",
  "Custom SQL Query"."ONLY_OSB_CASH" AS "ONLY_OSB_CASH",
  "Custom SQL Query"."OSB_ACTIVES" AS "OSB_ACTIVES",
  "Custom SQL Query"."OSB_CASH_ACTIVES" AS "OSB_CASH_ACTIVES",
  "Custom SQL Query"."OSB_CAS" AS "OSB_CAS",
  "Custom SQL Query"."OSB_CAS_CASH" AS "OSB_CAS_CASH",
  "Custom SQL Query"."TOTAL_ACTIVES" AS "TOTAL_ACTIVES",
  "Custom SQL Query"."TOTAL_CASH_ACTIVES" AS "TOTAL_CASH_ACTIVES"
FROM (
  WITH casino_actives AS (
    SELECT 
      DATE(DATE_TRUNC('day', CONVERT_TIMEZONE('America/Anchorage', 'America/New_York', session_end_time_alk))) AS date,
      CASE WHEN c.fund_type = 'CASH' THEN c.acco_id ELSE NULL END AS casino_cash_actives,
      c.acco_id AS casino_actives
    FROM fbg_analytics_engineering.casino.casino_sessions_mart c
    INNER JOIN fbg_source.osb_source.accounts a ON a.id = c.acco_id
    WHERE a.test = 0
      AND session_end_time_alk IS NOT NULL
      AND DATE > '2023-08-31'
    GROUP BY ALL
    ORDER BY date DESC
  ),
  
  sb_actives AS (
    SELECT
      DATE(DATE_TRUNC('day', CONVERT_TIMEZONE('UTC', 'America/New_York', a.placed_time))) AS day,
      CASE WHEN a.free_bet = 'FALSE' THEN a.acco_id ELSE NULL END AS osb_cash_actives,
      a.acco_id AS osb_actives
    FROM fbg_source.osb_source.bets a
    LEFT JOIN fbg_analytics_engineering.customers.customer_mart u ON u.acco_id = a.acco_id
    WHERE a.status IN ('ACCEPTED', 'SETTLED')
      AND a.test = 0
      AND DATE(DATE_TRUNC('day', CONVERT_TIMEZONE('UTC', 'America/New_York', a.placed_time))) > '2023-08-31'
    GROUP BY ALL
    ORDER BY 1 DESC
  ),
  
  both_active AS (
    SELECT 
      s.day AS date,
      COUNT(DISTINCT s.osb_actives) AS osb_cas
    FROM sb_actives s
    INNER JOIN casino_actives c ON s.day = c.date AND s.osb_actives = c.casino_actives
    GROUP BY ALL
    ORDER BY date DESC
  ),
  
  cas_active AS (
    SELECT 
      c.date,
      COUNT(DISTINCT c.casino_actives) AS only_cas
    FROM casino_actives c
    LEFT JOIN sb_actives s ON s.day = c.date AND s.osb_actives = c.casino_actives
    WHERE s.osb_actives IS NULL
    GROUP BY ALL
  ),
  
  sb_active AS (
    SELECT 
      s.day,
      COUNT(DISTINCT s.osb_actives) AS only_osb
    FROM sb_actives s
    LEFT JOIN casino_actives c ON c.date = s.day AND c.casino_actives = s.osb_actives
    WHERE c.casino_actives IS NULL
    GROUP BY ALL
  ),
  
  both_cash AS (
    SELECT 
      s.day AS date,
      COUNT(DISTINCT s.osb_cash_actives) AS osb_cas_cash
    FROM sb_actives s
    INNER JOIN casino_actives c ON s.day = c.date AND s.osb_cash_actives = c.casino_cash_actives
    GROUP BY ALL
    ORDER BY date DESC
  ),
  
  cas_cash AS (
    SELECT 
      c.date,
      COUNT(DISTINCT c.casino_cash_actives) AS only_cas_cash
    FROM casino_actives c
    LEFT JOIN sb_actives s ON s.day = c.date AND s.osb_cash_actives = c.casino_cash_actives
    WHERE s.osb_cash_actives IS NULL
    GROUP BY ALL
  ),
  
  sb_cash AS (
    SELECT 
      s.day,
      COUNT(DISTINCT s.osb_cash_actives) AS only_osb_cash
    FROM sb_actives s
    LEFT JOIN casino_actives c ON c.date = s.day AND c.casino_cash_actives = s.osb_cash_actives
    WHERE c.casino_cash_actives IS NULL
    GROUP BY ALL
  ),
  
  final AS (
    SELECT 
      b.date,
      osb_cas,
      only_cas,
      only_osb,
      osb_cas_cash,
      only_cas_cash,
      only_osb_cash,
      osb_cas + only_cas + only_osb AS total_actives,
      osb_cas_cash + only_cas_cash + only_osb_cash AS total_cash_actives,
      osb_cas + only_cas AS casino_actives,
      osb_cas + only_osb AS osb_actives,
      osb_cas_cash + only_cas_cash AS casino_cash_actives,
      osb_cas_cash + only_osb_cash AS osb_cash_actives
    FROM both_active b
    LEFT JOIN cas_active c ON c.date = b.date
    LEFT JOIN sb_active s ON s.day = b.date
    LEFT JOIN both_cash bc ON bc.date = b.date
    LEFT JOIN cas_cash cc ON cc.date = b.date
    LEFT JOIN sb_cash sc ON sc.day = b.date
    GROUP BY ALL
  )
  
  SELECT *
  FROM final
  ORDER BY date DESC
) "Custom SQL Query"
