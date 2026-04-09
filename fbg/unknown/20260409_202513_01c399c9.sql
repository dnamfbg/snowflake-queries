-- Query ID: 01c399c9-0212-67a9-24dd-07031927ff7b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:25:13.740000+00:00
-- Elapsed: 1402ms
-- Environment: FBG

WITH old AS (
    SELECT settled_date_alk,
           SUM(total_stake) AS total_stake,
           SUM(ggr) AS ggr,
           SUM(ngr) AS ngr,
           SUM(expected_ggr) AS expected_ggr
    FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
    WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
    GROUP BY 1
),
new AS (
    SELECT settled_date_alk,
           SUM(total_stake_usd) AS total_stake,
           SUM(ggr_usd) AS ggr,
           SUM(ngr_usd) AS ngr,
           SUM(expected_ggr_usd) AS expected_ggr
    FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
    WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
    GROUP BY 1
)
SELECT o.settled_date_alk,
       o.total_stake AS old_stake, n.total_stake AS new_stake,
       ROUND(o.total_stake - n.total_stake, 2) AS stake_diff,
       ROUND(o.ggr - n.ggr, 2) AS ggr_diff,
       ROUND(o.ngr - n.ngr, 2) AS ngr_diff,
       ROUND(o.expected_ggr - n.expected_ggr, 2) AS exp_ggr_diff
FROM old o
JOIN new n ON o.settled_date_alk = n.settled_date_alk
WHERE ABS(o.total_stake - n.total_stake) > 0.01
   OR ABS(o.ggr - n.ggr) > 0.01
   OR ABS(o.ngr - n.ngr) > 0.01
   OR ABS(o.expected_ggr - n.expected_ggr) > 0.01
ORDER BY 1
