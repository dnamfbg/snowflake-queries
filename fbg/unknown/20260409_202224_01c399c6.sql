-- Query ID: 01c399c6-0212-6e7d-24dd-07031927aa5b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:22:24.665000+00:00
-- Elapsed: 2768ms
-- Environment: FBG

SELECT 
    'casino_daily_settled_agg' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT settled_date_alk) AS distinct_dates,
    MIN(settled_date_alk) AS min_date,
    MAX(settled_date_alk) AS max_date
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-06'
UNION ALL
SELECT 
    'gold__casino_daily_settled_agg_usd',
    COUNT(*),
    COUNT(DISTINCT settled_date_alk),
    MIN(settled_date_alk),
    MAX(settled_date_alk)
FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-06'
