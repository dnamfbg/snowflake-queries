-- Query ID: 01c39a17-0212-6cb9-24dd-0703193a381b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:43:33.659000+00:00
-- Elapsed: 3209ms
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
AND agent_name IN ('Gaga Hamre')
  AND CASE_TYPE <> 'Unknown'
--GROUP BY DATE_TRUNC('month', date)
--ORDER BY month_start;
