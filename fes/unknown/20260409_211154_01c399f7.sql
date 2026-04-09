-- Query ID: 01c399f7-0112-6f44-0000-e307218b1686
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:11:54.910000+00:00
-- Elapsed: 22852ms
-- Environment: FES

WITH quarter_data AS (
    SELECT period_start AS start_quarter, period_end AS end_quarter
    FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
    WHERE period_type = 'quarter' AND period_label = 'Q1 26 TTM'
),
fbg_only_emails AS (
    SELECT DISTINCT emutd.hashed_email
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT emutd
    INNER JOIN quarter_data md ON DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN md.start_quarter AND md.end_quarter
    WHERE emutd.hashed_email IS NOT NULL
      AND emutd.tenant_id = '100002'
      AND emutd.hashed_email NOT IN (
          SELECT DISTINCT hashed_email
          FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT e2
          INNER JOIN quarter_data md2 ON DATEFROMPARTS(e2.year, e2.month, 1) BETWEEN md2.start_quarter AND md2.end_quarter
          WHERE e2.tenant_id != '100002' AND e2.hashed_email IS NOT NULL
      )
),
cde_mapped AS (
    SELECT DISTINCT MD5(LOWER(TRIM(acc.email))) AS hashed_email
    FROM CDE.CDE_CORE.TOTAL_REVENUE cde
    INNER JOIN FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS acc ON cde.customer_id = acc.id
    CROSS JOIN quarter_data md
    WHERE cde.bus_date BETWEEN md.start_quarter AND md.end_quarter
      AND cde.active_flag = TRUE
      AND acc.email IS NOT NULL
),
unmatched AS (
    SELECT f.hashed_email
    FROM fbg_only_emails f
    LEFT JOIN cde_mapped cm ON f.hashed_email = cm.hashed_email
    WHERE cm.hashed_email IS NULL
)
SELECT
    emutd.source,
    COUNT(DISTINCT emutd.hashed_email) AS users
FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT emutd
INNER JOIN quarter_data md ON DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN md.start_quarter AND md.end_quarter
WHERE emutd.hashed_email IN (SELECT hashed_email FROM unmatched)
  AND emutd.tenant_id = '100002'
GROUP BY emutd.source
ORDER BY users DESC
