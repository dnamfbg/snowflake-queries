-- Query ID: 01c39a53-0212-6cb9-24dd-070319473ba3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_L_WH_PROD
-- Executed: 2026-04-09T22:43:08.072000+00:00
-- Elapsed: 62940ms
-- Environment: FBG

WITH cases_raw AS (
  SELECT
    c.case_id,
    c.case_number,
    DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', c.case_created_est)) AS ddate,
    DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', c.case_closed_est))  AS closedddate
  FROM fbg_analytics.operations.cs_cases c
  WHERE c.case_created_est IS NOT NULL
    AND DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', c.case_created_est)) > '2024-08-31'
    AND c.case_source IN ('Inbound: Email','Inbound: Social Media')
),

-- ✅ ensure 1 row per case_number (in case cs_cases has duplicates/history)
cases AS (
  SELECT
    case_number,
    MIN(ddate)      AS ddate,
    MIN(closedddate) AS closedddate,
    MIN(case_id)    AS case_id
  FROM cases_raw
  GROUP BY 1
),

first_close AS (
  SELECT
    f.caseid,
    MIN(DATE(CONVERT_TIMEZONE('America/New_York','America/Anchorage', f.first_closed_time_est))) AS firstcloseddate
  FROM FBG_ANALYTICS.operations.case_first_closed_time f
  GROUP BY 1
),

work_by_case_day AS (
  SELECT
    l.day::DATE AS workdate,
    l.case_number,
    SUM(l.total_time_to_add_minutes) AS active_time
  FROM fbg_analytics.operations.ops_audit_log_daily l
  WHERE l.day::DATE > '2024-08-31'
  GROUP BY 1, 2
),

base_raw AS (
  SELECT
    c.ddate,
    c.closedddate,
    fc.firstcloseddate,
    c.case_number,
    w.active_time
  FROM cases c
  LEFT JOIN first_close fc
    ON fc.caseid = c.case_id
  LEFT JOIN work_by_case_day w
    ON w.case_number = c.case_number
   AND w.workdate   = c.ddate   -- same-day work only
),

-- ✅ THE IMPORTANT PART: collapse to 1 row per (ddate, case_number)
base AS (
  SELECT
    ddate,
    case_number,
    MAX(closedddate)     AS closedddate,
    MAX(firstcloseddate) AS firstcloseddate,
    MAX(COALESCE(active_time, 0)) AS active_time
  FROM base_raw
  GROUP BY 1, 2
),

newemails_total AS (
  SELECT
    ddate,
    COUNT(*) AS total_new_emails
  FROM base
  GROUP BY 1
),

worked_daily AS (
  SELECT
    ddate,
    COUNT(CASE WHEN active_time > 0 THEN 1 END) AS samedayemails,
    SUM(CASE WHEN active_time > 0 THEN active_time END) AS total_sameday_email_time
  FROM base
  GROUP BY 1
),

closed_daily AS (
  SELECT
    ddate,
    COUNT(CASE WHEN ddate = COALESCE(firstcloseddate, closedddate) THEN 1 END) AS newemailsclosed
  FROM base
  GROUP BY 1
)

SELECT
  t.ddate,
  t.total_new_emails,

  COALESCE(w.samedayemails, 0) AS samedayemails,
  CASE
    WHEN t.total_new_emails = 0 THEN 0
    ELSE COALESCE(w.samedayemails, 0) / t.total_new_emails::FLOAT
  END AS pct_new_emails_worked_today,

  -- ✅ average that must reconcile
  CASE
    WHEN COALESCE(w.samedayemails, 0) = 0 THEN NULL
    ELSE w.total_sameday_email_time / w.samedayemails::FLOAT
  END AS avg_sameday_email_time,

  w.total_sameday_email_time,

  COALESCE(c.newemailsclosed, 0) AS newemailsclosed,
  CASE
    WHEN t.total_new_emails = 0 THEN 0
    ELSE COALESCE(c.newemailsclosed, 0) / t.total_new_emails::FLOAT
  END AS closure_pct
  
FROM newemails_total t
LEFT JOIN worked_daily w
  ON t.ddate = w.ddate
LEFT JOIN closed_daily c
  ON t.ddate = c.ddate
WHERE t.ddate < DATE(convert_timezone('UTC', 'America/Anchorage', current_timestamp()))
ORDER BY 1 DESC;
