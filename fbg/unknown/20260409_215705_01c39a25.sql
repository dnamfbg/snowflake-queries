-- Query ID: 01c39a25-0212-644a-24dd-0703193cdc53
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:57:05.449000+00:00
-- Elapsed: 428ms
-- Environment: FBG

SELECT
    case_created_est::date AS dt,
    COUNT(*) AS total_cases
FROM fbg_analytics.operations.cs_cases
WHERE case_created_est::date BETWEEN CURRENT_DATE() - 35 AND CURRENT_DATE() - 1
GROUP BY dt
ORDER BY dt
