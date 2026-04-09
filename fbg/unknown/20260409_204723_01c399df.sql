-- Query ID: 01c399df-0212-6e7d-24dd-0703192cca9b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:47:23.853000+00:00
-- Elapsed: 1229ms
-- Environment: FBG

SELECT case_type, COUNT(*) AS cnt
FROM fbg_analytics.operations.cs_cases
WHERE case_created_est >= DATEADD('day', -35, CURRENT_DATE())
GROUP BY case_type
ORDER BY cnt DESC
LIMIT 20
