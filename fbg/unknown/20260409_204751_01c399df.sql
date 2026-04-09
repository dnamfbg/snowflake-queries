-- Query ID: 01c399df-0212-6e7d-24dd-0703192ccd1f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:47:51.716000+00:00
-- Elapsed: 456ms
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
        h.agent_handle_time_minutes,
        CASE
            WHEN h.accept_time::date BETWEEN dr.recent_start AND dr.end_date THEN 'Last 5 Days'
            WHEN h.accept_time::date BETWEEN dr.baseline_start AND dr.recent_start - 1 THEN 'Prior 30 Days'
        END AS period
    FROM fbg_analytics.operations.handle_time_outliers_removed h
    CROSS JOIN date_ranges dr
    WHERE h.accept_time::date BETWEEN dr.baseline_start AND dr.end_date
)
SELECT
    channel,
    period,
    COUNT(*) AS interactions,
    ROUND(AVG(agent_handle_time_minutes), 2) AS avg_aht_min,
    ROUND(MEDIAN(agent_handle_time_minutes), 2) AS median_aht_min,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY agent_handle_time_minutes), 2) AS p75_aht_min
FROM ht_tagged
WHERE period IS NOT NULL
GROUP BY channel, period
ORDER BY channel, period
