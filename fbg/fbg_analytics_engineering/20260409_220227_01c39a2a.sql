-- Query ID: 01c39a2a-0212-6dbe-24dd-0703193e811b
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:02:27.129000+00:00
-- Elapsed: 2816ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."CASES" AS "CASES",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."FTUS" AS "FTUS",
  "Custom SQL Query"."REG_STATE" AS "REG_STATE"
FROM (
  WITH actives AS (
  SELECT DATE_TRUNC('hour', fbg_ftu_date_est) AS date,
  COUNT(DISTINCT acco_id) AS FTUs,
  u.registration_state AS reg_state
  FROM fbg_analytics_engineering.customers.customer_mart u
  WHERE fbg_ftu_date_est IS NOT NULL
  AND u.is_test_account = 'FALSE'
  AND u.acquisition_bonus_name IN ('Bet $50 Get $250 Sequenced', 'Bet $50, Get $250', 'Bet $50, Get $250 in FanCash','Bet $50 Get $250 FC Sequenced','Bet $50 Get $250 FanCash Sequenced')
  AND u.acquisition_channel != 'PB Created Acct'
  AND is_kiosk = 'FALSE'
  AND DATE_TRUNC('hour', fbg_ftu_date_est) >= '2024-06-20'
  GROUP BY DATE_TRUNC('hour', fbg_ftu_date_est), u.registration_state
  ),
  
  cases AS (
  SELECT COUNT(DISTINCT c.case_number) AS cases,
  DATE_TRUNC('hour', c.case_created_est) AS created_date,
  c.case_subtype AS sub_type,
  u.registration_state AS reg_state
  FROM fbg_analytics.operations.cs_cases c
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart u ON c.account_id = u.acco_id
  WHERE c.case_subtype = ('Bet $50 Get $250')
  AND created_date >= '2024-06-20'
  GROUP BY created_date, c.case_subtype, u.registration_state
  )
  
  SELECT COALESCE(a.date, c.created_date) AS date,
  SUM(COALESCE(c.cases, 0)) AS cases,
  SUM(COALESCE(a.FTUs, 0)) AS FTUs,
  COALESCE(c.reg_state, a.reg_state) AS reg_state
  FROM actives a
  FULL OUTER JOIN cases c ON a.date = c.created_date AND a.reg_state = c.reg_state
  GROUP BY COALESCE(a.date, c.created_date), COALESCE(c.reg_state, a.reg_state)
  ORDER BY date DESC
) "Custom SQL Query"
