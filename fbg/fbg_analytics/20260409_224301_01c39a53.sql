-- Query ID: 01c39a53-0212-6dbe-24dd-070319472b9f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:43:01.041000+00:00
-- Elapsed: 4584ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."JURISDICTION_NAME" AS "JURISDICTION_NAME",
  "Custom SQL Query"."REG_DATE" AS "REG_DATE",
  "Custom SQL Query"."STATUS" AS "STATUS"
FROM (
  select 
  acc.id as acco_id,
  jurisdiction_name,
  status,
  date_trunc('hour',convert_timezone('UTC','America/New_York',acc.creation_date)) as reg_date
  from FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS J on acc.reg_jurisdictions_id = j.Id
  where acc.test = 0
  QUALIFY row_number() OVER (PARTITION BY acc.id ORDER BY creation_date desc) = 1
) "Custom SQL Query"
