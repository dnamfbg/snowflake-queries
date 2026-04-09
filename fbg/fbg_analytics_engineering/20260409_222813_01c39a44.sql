-- Query ID: 01c39a44-0212-6cb9-24dd-0703194450a3
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:28:13.609000+00:00
-- Elapsed: 92ms
-- Environment: FBG

SELECT "Custom SQL Query"."EVENT_HOUR" AS "EVENT_HOUR",
  "Custom SQL Query"."FIRST_PRODUCT" AS "FIRST_PRODUCT",
  "Custom SQL Query"."FTUS" AS "FTUS",
  "Custom SQL Query"."HIGH_LEVEL_CHANNEL" AS "HIGH_LEVEL_CHANNEL",
  "Custom SQL Query"."KYC_STATUS" AS "KYC_STATUS",
  "Custom SQL Query"."REGS" AS "REGS",
  "Custom SQL Query"."STATE" AS "STATE"
FROM (
  WITH regs AS (
    SELECT 
        DATE_TRUNC('HOUR', registration_date_est) AS event_hour,
        registration_state AS state,
        status,
        CASE WHEN acquisition_channel IN ('Search', 'Social', 'App Networks', 'Affiliate') THEN 'Performance'
  WHEN acquisition_channel = 'Referral' THEN 'RAF'
  WHEN acquisition_channel = 'Organic & Other' THEN 'Organic'
  WHEN acquisition_channel = 'Cross-Sell' THEN 'X-Sell'
  WHEN acquisition_channel = 'FanApp' THEN 'FanApp'
  ELSE 'Other'
  END as high_level_channel,
  acquisition_channel,
        first_product,
        COUNT(DISTINCT acco_id) AS regs
    FROM fbg_analytics.product_and_customer.acquisition_customer_mart
    WHERE registration_date_est IS NOT NULL
      AND registration_date_est >= '2024-01-01'
    GROUP BY 1,2,3,4,5,6
  ),
  ftus AS (
    SELECT 
        DATE_TRUNC('HOUR', fbg_ftu_date_est) AS event_hour,
        registration_state AS state,
        status,
        CASE WHEN acquisition_channel IN ('Search', 'Social', 'App Networks', 'Affiliate') THEN 'Performance'
  WHEN acquisition_channel = 'Referral' THEN 'RAF'
  WHEN acquisition_channel = 'Organic & Other' THEN 'Organic'
  WHEN acquisition_channel = 'Cross-Sell' THEN 'X-Sell'
  WHEN acquisition_channel = 'FanApp' THEN 'FanApp'
  ELSE 'Other'
  END as high_level_channel,
  acquisition_channel,
        first_product,
        COUNT(DISTINCT acco_id) AS ftus
    FROM fbg_analytics.product_and_customer.acquisition_customer_mart
    WHERE fbg_ftu_date_est IS NOT NULL
      AND fbg_ftu_date_est >= '2024-01-01'
    GROUP BY 1,2,3,4,5,6
  )
  SELECT 
      COALESCE(r.event_hour, f.event_hour) AS event_hour,
      COALESCE(r.state, f.state)           AS state,
      COALESCE(r.status, f.status) AS kyc_status,
      COALESCE(r.high_level_channel, f.high_level_channel) AS high_level_channel,
      COALESCE(r.first_product, f.first_product) AS first_product,
      COALESCE(r.regs, 0) AS regs,
      COALESCE(f.ftus, 0) AS ftus
  FROM regs r
  FULL OUTER JOIN ftus f
    ON r.event_hour = f.event_hour
   AND r.state      = f.state
   AND r.status = f.status
   AND r.acquisition_channel = f.acquisition_channel
   AND r.first_product = f.first_product
  ORDER BY 1 DESC, 2
) "Custom SQL Query"
