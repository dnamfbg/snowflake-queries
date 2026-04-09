-- Query ID: 01c39a47-0212-6e7d-24dd-07031944e127
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T22:31:59.546000+00:00
-- Elapsed: 485231ms
-- Environment: FBG

WITH containment AS (
      SELECT case_number, MAX(COALESCE(is_contained_overall, 0)) AS is_contained_overall
      FROM fbg_analytics.operations.cs_containment
      GROUP BY 1
    ),
    cases_raw AS (
      SELECT
        c.case_id, c.case_number, c.case_source,
        DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', c.case_created_est)) AS ddate
      FROM fbg_analytics.operations.cs_cases c
      LEFT JOIN containment x ON c.case_number = x.case_number
      WHERE c.case_created_est IS NOT NULL
        AND DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', c.case_created_est)) > '2024-08-31'
        AND COALESCE(x.is_contained_overall, 0) <> 1
        AND c.case_source IN ('Inbound: Chat - Agent','Inbound: ChatBot','Inbound: Email')
    ),
    cases AS (
      SELECT case_number, MIN(ddate) AS ddate, MIN(case_id) AS case_id, MIN(case_source) AS case_source
      FROM cases_raw
      GROUP BY 1
    ),
    work_by_case_day AS (
      SELECT l.day::DATE AS workdate, l.case_number, SUM(l.total_time_to_add_minutes) AS active_time
      FROM fbg_analytics.operations.ops_audit_log_daily l
      WHERE l.day::DATE > '2024-08-31'
      GROUP BY 1, 2
    ),
    base AS (
      SELECT
        c.ddate,
        c.case_number,
        c.case_source,
        COALESCE(w.active_time, 0) AS active_time
      FROM cases c
      LEFT JOIN work_by_case_day w ON w.case_number = c.case_number AND w.workdate = c.ddate
    )
    SELECT
      ddate,
      CASE WHEN SUM(CASE WHEN active_time > 0 THEN 1 END) > 0
           THEN SUM(CASE WHEN active_time > 0 THEN active_time END) / SUM(CASE WHEN active_time > 0 THEN 1 END)::FLOAT
           ELSE NULL END AS avg_daily_case_time,
      CASE WHEN SUM(CASE WHEN active_time > 0 AND case_source IN ('Inbound: Chat - Agent','Inbound: ChatBot') THEN 1 END) > 0
           THEN SUM(CASE WHEN active_time > 0 AND case_source IN ('Inbound: Chat - Agent','Inbound: ChatBot') THEN active_time END)
                / SUM(CASE WHEN active_time > 0 AND case_source IN ('Inbound: Chat - Agent','Inbound: ChatBot') THEN 1 END)::FLOAT
           ELSE NULL END AS avg_daily_chat_time,
      CASE WHEN SUM(CASE WHEN active_time > 0 AND case_source = 'Inbound: Email' THEN 1 END) > 0
           THEN SUM(CASE WHEN active_time > 0 AND case_source = 'Inbound: Email' THEN active_time END)
                / SUM(CASE WHEN active_time > 0 AND case_source = 'Inbound: Email' THEN 1 END)::FLOAT
           ELSE NULL END AS avg_daily_email_time
    FROM base
    GROUP BY 1
    ORDER BY 1 DESC
