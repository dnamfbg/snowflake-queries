-- Query ID: 01c39a44-0212-6e7d-24dd-07031944481f
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:28:56.358000+00:00
-- Elapsed: 64ms
-- Environment: FBG

SELECT "Custom SQL Query"."MAX(REGISTRATION_DATE_EST)" AS "MAX(REGISTRATION_DATE_EST)"
FROM (
  SELECT max(registration_date_est)
  FROM fbg_analytics.product_and_customer.acquisition_customer_mart
) "Custom SQL Query"
