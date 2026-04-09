-- Query ID: 01c399e8-0212-67a9-24dd-0703192e8bc3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:56:46.003000+00:00
-- Elapsed: 2137ms
-- Environment: FBG

WITH date_ranges AS (
    SELECT
        CURRENT_DATE() - 1 AS end_date,
        CURRENT_DATE() - 5 AS recent_start,
        CURRENT_DATE() - 35 AS baseline_start
),
kyc_by_channel AS (
    SELECT
        h.channel,
        CASE
            WHEN h.accept_time::date BETWEEN dr.recent_start AND dr.end_date THEN 'Last 5 Days'
            WHEN h.accept_time::date BETWEEN dr.baseline_start AND dr.recent_start - 1 THEN 'Prior 30 Days'
        END AS period,
        COUNT(*) AS interactions,
        ROUND(AVG(h.agent_handle_time_minutes), 2) AS avg_aht,
        ROUND(MEDIAN(h.agent_handle_time_minutes), 2) AS median_aht
    FROM fbg_analytics.operations.handle_time_outliers_removed h
    CROSS JOIN date_ranges dr
    JOIN fbg_analytics.operations.cs_cases c ON h.case_id = c.case_id
    WHERE c.case_type = 'KYC'
      AND h.accept_time::date BETWEEN dr.baseline_start AND dr.end_date
    GROUP BY h.channel, period
),
period_totals AS (
    SELECT period, SUM(interactions) AS total
    FROM kyc_by_channel
    WHERE period IS NOT NULL
    GROUP BY period
)
SELECT
    k.channel,
    k.period,
    k.interactions,
    ROUND(100.0 * k.interactions / pt.total, 2) AS pct_of_kyc,
    k.avg_aht,
    k.median_aht
FROM kyc_by_channel k
JOIN period_totals pt ON k.period = pt.period
WHERE k.period IS NOT NULL
ORDER BY k.channel, k.period
