-- Query ID: 01c39a1e-0212-67a9-24dd-0703193b9677
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:50:08.123000+00:00
-- Elapsed: 494ms
-- Environment: FBG

WITH date_ranges AS (
    SELECT
        CURRENT_DATE() - 1 AS end_date,
        CURRENT_DATE() - 5 AS recent_start,
        CURRENT_DATE() - 35 AS baseline_start
),
ht_tagged AS (
    SELECT
        h.channel,
        CASE
            WHEN h.accept_time::date BETWEEN dr.recent_start AND dr.end_date THEN 'Last 5 Days'
            WHEN h.accept_time::date BETWEEN dr.baseline_start AND dr.recent_start - 1 THEN 'Prior 30 Days'
        END AS period
    FROM fbg_analytics.operations.handle_time_outliers_removed h
    CROSS JOIN date_ranges dr
    WHERE h.accept_time::date BETWEEN dr.baseline_start AND dr.end_date
),
period_totals AS (
    SELECT period, COUNT(*) AS total
    FROM ht_tagged WHERE period IS NOT NULL
    GROUP BY period
)
SELECT
    t.channel,
    t.period,
    COUNT(*) AS interactions,
    ROUND(100.0 * COUNT(*) / pt.total, 2) AS pct_of_total,
    ROUND(COUNT(*) / CASE
        WHEN t.period = 'Last 5 Days' THEN 5.0
        ELSE 30.0
    END, 0) AS avg_daily_vol
FROM ht_tagged t
JOIN period_totals pt ON t.period = pt.period
WHERE t.period IS NOT NULL
GROUP BY t.channel, t.period, pt.total
ORDER BY t.channel, t.period
