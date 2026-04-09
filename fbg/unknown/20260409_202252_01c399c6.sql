-- Query ID: 01c399c6-0212-644a-24dd-07031928107b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:22:52.160000+00:00
-- Elapsed: 5644ms
-- Environment: FBG

WITH old_keys AS (
    SELECT acco_id, game_id, platform_id, settled_date_alk, state, currency
    FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
    WHERE settled_date_alk IN ('2026-04-05', '2026-04-06')
),
new_keys AS (
    SELECT acco_id, game_id, platform_id, settled_date_alk, state, currency
    FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
    WHERE settled_date_alk IN ('2026-04-05', '2026-04-06')
)
SELECT o.settled_date_alk, o.currency, COUNT(*) AS missing_rows
FROM old_keys o
LEFT JOIN new_keys n 
    ON o.acco_id = n.acco_id 
    AND o.game_id = n.game_id 
    AND o.platform_id = n.platform_id 
    AND o.settled_date_alk = n.settled_date_alk
    AND o.state = n.state
    AND o.currency = n.currency
WHERE n.acco_id IS NULL
GROUP BY 1, 2
ORDER BY 1, 2
