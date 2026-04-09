-- Query ID: 01c399f0-0212-644a-24dd-07031930e0cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:04:22.075000+00:00
-- Elapsed: 291ms
-- Environment: FBG

WITH date_ranges AS (
        SELECT
            CURRENT_DATE() - 1 AS end_date,        -- yesterday (today may be partial)
            CURRENT_DATE() - 5 AS recent_start,     -- last 5 days
            CURRENT_DATE() - 35 AS baseline_start   -- prior 30 days
    ),
    cases_tagged AS (
        SELECT
            c.case_type,
            CASE
                WHEN c.case_created_est::date BETWEEN dr.recent_start AND dr.end_date THEN 'Last 5 Days'
                WHEN c.case_created_est::date BETWEEN dr.baseline_start AND dr.recent_start - 1 THEN 'Prior 30 Days'
            END AS period
        FROM fbg_analytics.operations.cs_cases c
        CROSS JOIN date_ranges dr
        WHERE c.case_created_est::date BETWEEN dr.baseline_start AND dr.end_date
    ),
    period_totals AS (
        SELECT period, COUNT(*) AS total_cases
        FROM cases_tagged
        WHERE period IS NOT NULL
        GROUP BY period
    ),
    type_counts AS (
        SELECT
            COALESCE(case_type, 'Null/Blank') AS case_type,
            period,
            COUNT(*) AS cases
        FROM cases_tagged
        WHERE period IS NOT NULL
        GROUP BY case_type, period
    )
    SELECT
        tc.case_type,
        MAX(CASE WHEN tc.period = 'Prior 30 Days' THEN tc.cases END) AS prior_30d_cases,
        MAX(CASE WHEN tc.period = 'Prior 30 Days' THEN ROUND(100.0 * tc.cases / pt.total_cases, 2) END) AS prior_30d_pct,
        MAX(CASE WHEN tc.period = 'Last 5 Days' THEN tc.cases END) AS last_5d_cases,
        MAX(CASE WHEN tc.period = 'Last 5 Days' THEN ROUND(100.0 * tc.cases / pt.total_cases, 2) END) AS last_5d_pct,
        ROUND(
            COALESCE(MAX(CASE WHEN tc.period = 'Last 5 Days' THEN 100.0 * tc.cases / pt.total_cases END), 0)
            - COALESCE(MAX(CASE WHEN tc.period = 'Prior 30 Days' THEN 100.0 * tc.cases / pt.total_cases END), 0),
            2
        ) AS pct_point_shift
    FROM type_counts tc
    JOIN period_totals pt ON tc.period = pt.period
    GROUP BY tc.case_type
    ORDER BY ABS(pct_point_shift) DESC
