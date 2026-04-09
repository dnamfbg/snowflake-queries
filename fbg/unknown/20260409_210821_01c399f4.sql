-- Query ID: 01c399f4-0212-6dbe-24dd-070319318bdb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:08:21.704000+00:00
-- Elapsed: 170ms
-- Environment: FBG

WITH date_ranges AS (
        SELECT
            CURRENT_DATE() - 1 AS end_date,
            CURRENT_DATE() - 5 AS recent_start,
            CURRENT_DATE() - 35 AS baseline_start
    ),
    joined AS (
        SELECT
            COALESCE(c.case_type, 'Null/Blank') AS case_type,
            h.channel,
            h.agent_handle_time_minutes,
            CASE
                WHEN h.accept_time::date BETWEEN dr.recent_start AND dr.end_date THEN 'Last 5 Days'
                WHEN h.accept_time::date BETWEEN dr.baseline_start AND dr.recent_start - 1 THEN 'Prior 30 Days'
            END AS period
        FROM fbg_analytics.operations.handle_time_outliers_removed h
        CROSS JOIN date_ranges dr
        JOIN fbg_analytics.operations.cs_cases c ON h.case_id = c.case_id
        WHERE h.accept_time::date BETWEEN dr.baseline_start AND dr.end_date
    )
    SELECT
        case_type,
        channel,
        MAX(CASE WHEN period = 'Prior 30 Days' THEN interactions END) AS prior_30d_interactions,
        MAX(CASE WHEN period = 'Prior 30 Days' THEN avg_aht END) AS prior_30d_avg_aht,
        MAX(CASE WHEN period = 'Last 5 Days' THEN interactions END) AS last_5d_interactions,
        MAX(CASE WHEN period = 'Last 5 Days' THEN avg_aht END) AS last_5d_avg_aht,
        ROUND(
            COALESCE(MAX(CASE WHEN period = 'Last 5 Days' THEN avg_aht END), 0)
            - COALESCE(MAX(CASE WHEN period = 'Prior 30 Days' THEN avg_aht END), 0),
            2
        ) AS aht_change_min
    FROM (
        SELECT
            case_type,
            channel,
            period,
            COUNT(*) AS interactions,
            ROUND(AVG(agent_handle_time_minutes), 2) AS avg_aht
        FROM joined
        WHERE period IS NOT NULL
        GROUP BY case_type, channel, period
    ) sub
    GROUP BY case_type, channel
    HAVING prior_30d_interactions >= 50 OR last_5d_interactions >= 50
    ORDER BY ABS(aht_change_min) DESC
