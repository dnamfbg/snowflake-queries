-- Query ID: 01c39a2d-0212-6e7d-24dd-0703193f13ff
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:05:18.283000+00:00
-- Elapsed: 2973ms
-- Environment: FBG

SELECT 
    --DATE_TRUNC('month', date) AS month_start,
    SUM(lowcsats)  AS total_lowcsats,
    SUM(highcsats) AS total_highcsats,
    CASE 
        WHEN SUM(lowcsats) = 0 THEN 0
        ELSE SUM(highcsats) / SUM(lowcsats) 
    END AS csat_plus
FROM fbg_analytics.operations.aer_dash
WHERE date BETWEEN '2025-11-30' AND '2026-03-29'
AND agent_name IN ('Shawn Palathinkal')
  AND CASE_TYPE <> 'Unknown'
--GROUP BY DATE_TRUNC('month', date)
--ORDER BY month_start;
