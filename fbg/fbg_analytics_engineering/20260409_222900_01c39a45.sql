-- Query ID: 01c39a45-0212-67a9-24dd-0703194439a7
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:29:00.321000+00:00
-- Elapsed: 64339ms
-- Environment: FBG

SELECT "Custom SQL Query"."FTU_DATE" AS "FTU_DATE"
FROM (
  SELeCT max(convert_timezone('UTC','America/New_York', trans_date)) as ftu_date
  from FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS
) "Custom SQL Query"
