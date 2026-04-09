-- Query ID: 01c39a0c-0212-6e7d-24dd-070319375787
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:32:13.910000+00:00
-- Elapsed: 849ms
-- Environment: FBG

SELECT 
  case_id,
  case_number,
  account_id,
  case_type,
  case_subtype,
  csat_score,
  case_closed_est,
  agent_name,
  case_status,
  customer_comments
FROM fbg_analytics.operations.cs_cases_fmx c
WHERE product_flag = 'FMX'
  AND csat_score IS NOT NULL
  AND customer_comments IS NOT NULL
  AND (
    UPPER(customer_comments) ILIKE '%NOT RESOLVED%'
    OR UPPER(customer_comments) ILIKE '%NEVER RESOLVED%'
    OR UPPER(customer_comments) ILIKE '%STILL NOT%'
    OR UPPER(customer_comments) ILIKE '%STILL HAVEN''T%'
    OR UPPER(customer_comments) ILIKE '%NEED HELP%'
    OR UPPER(customer_comments) ILIKE '%DIDN''T RESOLVE%'
    OR UPPER(customer_comments) ILIKE '%PHONE NUMBER%'
    OR UPPER(customer_comments) ILIKE '%CALL ME%'
    OR UPPER(customer_comments) ILIKE '%ADD RESPONSE%'
  )
  AND case_closed_est >= DATEADD(HOUR, -48, CURRENT_TIMESTAMP())
ORDER BY case_closed_est DESC;
