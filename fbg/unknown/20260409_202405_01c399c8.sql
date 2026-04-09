-- Query ID: 01c399c8-0212-67a9-24dd-07031927f9a7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:24:05.824000+00:00
-- Elapsed: 1544ms
-- Environment: FBG

WITH old AS (
    SELECT settled_date_alk, COUNT(*) AS cnt
    FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
    WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
    GROUP BY 1
),
new AS (
    SELECT settled_date_alk, COUNT(*) AS cnt
    FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
    WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
    GROUP BY 1
)
SELECT 
    COALESCE(o.settled_date_alk, n.settled_date_alk) AS settled_date,
    o.cnt AS old_rows,
    n.cnt AS new_rows,
    COALESCE(o.cnt, 0) - COALESCE(n.cnt, 0) AS diff
FROM old o
FULL OUTER JOIN new n ON o.settled_date_alk = n.settled_date_alk
WHERE COALESCE(o.cnt, 0) != COALESCE(n.cnt, 0)
ORDER BY 1
