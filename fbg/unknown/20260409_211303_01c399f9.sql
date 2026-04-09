-- Query ID: 01c399f9-0212-6cb9-24dd-07031933101b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:13:03.465000+00:00
-- Elapsed: 1945ms
-- Environment: FBG

SELECT
    COALESCE(c.case_type, 'Null/Blank') AS case_type,
    COUNT(*) AS interactions,
    ROUND(AVG(h.agent_handle_time_minutes), 2) AS avg_aht,
    ROUND(MEDIAN(h.agent_handle_time_minutes), 2) AS median_aht,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY h.agent_handle_time_minutes), 2) AS p75_aht
FROM fbg_analytics.operations.handle_time_outliers_removed h
JOIN fbg_analytics.operations.cs_cases c ON h.case_id = c.case_id
WHERE h.accept_time::date >= CURRENT_DATE() - 35
GROUP BY case_type
HAVING COUNT(*) >= 100
ORDER BY avg_aht DESC
