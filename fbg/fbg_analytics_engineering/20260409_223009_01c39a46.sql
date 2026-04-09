-- Query ID: 01c39a46-0212-67a8-24dd-070319448493
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:30:09.285000+00:00
-- Elapsed: 44ms
-- Environment: FBG

SELECT "Custom SQL Query"."MAX(REG_DATE)" AS "MAX(REG_DATE)"
FROM (
  SELECT max(reg_date)
  FROM fbg_analytics_engineering.customers.user_acquisition_bonus_lookup
) "Custom SQL Query"
