-- Query ID: 01c39a17-0212-6e7d-24dd-0703193a28b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:43:04.308000+00:00
-- Elapsed: 481ms
-- Environment: FBG

SELECT 
  TO_CHAR(SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS ftu_cohort,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN D90 <= CURRENT_DATE() THEN 1 ELSE 0 END) AS have_d90,
  ROUND(SUM(CASE WHEN D90 <= CURRENT_DATE() THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_complete
FROM fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2
WHERE SPORTSBOOK_FTU_DATE_ALK >= '2025-09-01'
GROUP BY 1
ORDER BY 1
