-- Query ID: 01c39a43-0212-67a8-24dd-0703194420df
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:27:26.662000+00:00
-- Elapsed: 56ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."EVENT_HOUR" AS "EVENT_HOUR",
  "Custom SQL Query"."FIRST_PRODUCT" AS "FIRST_PRODUCT",
  "Custom SQL Query"."FTUS" AS "FTUS",
  "Custom SQL Query"."KYC_STATUS" AS "KYC_STATUS",
  "Custom SQL Query"."REGS" AS "REGS",
  "Custom SQL Query"."STATE" AS "STATE"
FROM (
  WITH regs AS (
    SELECT 
        DATE_TRUNC('HOUR', reg_date) AS event_hour,
        registration_state AS state,
        kyc_status,
        acquisition_bonus_name,
        first_product,
        COUNT(DISTINCT acco_id) AS regs
    FROM fbg_analytics_engineering.customers.user_acquisition_bonus_lookup
    WHERE reg_date IS NOT NULL
      AND reg_date >= '2024-01-01'
    GROUP BY 1,2,3,4,5
  ),
  ftus AS (
    SELECT 
        DATE_TRUNC('HOUR', first_bet_date) AS event_hour,
        registration_state AS state,
        kyc_status,
        acquisition_bonus_name,
        first_product,
        COUNT(DISTINCT acco_id) AS ftus
    FROM fbg_analytics_engineering.customers.user_acquisition_bonus_lookup
    WHERE first_bet_date IS NOT NULL
      AND first_bet_date >= '2024-01-01'
    GROUP BY 1,2,3,4,5
  )
  SELECT 
      COALESCE(r.event_hour, f.event_hour) AS event_hour,
      COALESCE(r.state, f.state)           AS state,
      COALESCE(r.kyc_status, f.kyc_status) AS kyc_status,
      COALESCE(r.acquisition_bonus_name, f.acquisition_bonus_name) AS acquisition_bonus_name,
      COALESCE(r.first_product, f.first_product) AS first_product,
      COALESCE(r.regs, 0) AS regs,
      COALESCE(f.ftus, 0) AS ftus
  FROM regs r
  FULL OUTER JOIN ftus f
    ON r.event_hour = f.event_hour
   AND r.state      = f.state
   AND r.kyc_status = f.kyc_status
   AND r.acquisition_bonus_name = f.acquisition_bonus_name
   AND r.first_product = f.first_product
  ORDER BY 1 DESC, 2
) "Custom SQL Query"
