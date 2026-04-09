-- Query ID: 01c399eb-0112-6ccc-0000-e3072189ef5a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:59:42.597000+00:00
-- Elapsed: 21496ms
-- Environment: FES

WITH quarter_data AS (
    SELECT period_start AS start_quarter, period_end AS end_quarter
    FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
    WHERE period_type = 'quarter' AND period_label = 'Q1 26 TTM'
),
-- FBG Only hashed_emails for Q1 26 TTM
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
-- CDE vertical flags mapped to hashed_email
cde_mapped AS (
    SELECT
        MD5(LOWER(TRIM(acc.email))) AS hashed_email,
        MAX(IFF(cde.active_flag AND cde.subledger_application = 'iGaming', 1, 0)) AS has_igaming,
        MAX(IFF(cde.active_flag AND cde.subledger_application = 'iCasino', 1, 0)) AS has_icasino,
        MAX(IFF(cde.active_flag AND cde.subledger_application = 'Retail Sportsbook', 1, 0)) AS has_retail
    FROM CDE.CDE_CORE.TOTAL_REVENUE cde
    INNER JOIN FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS acc ON cde.customer_id = acc.id
    CROSS JOIN quarter_data md
    WHERE cde.bus_date BETWEEN md.start_quarter AND md.end_quarter
      AND cde.active_flag = TRUE
      AND acc.email IS NOT NULL
    GROUP BY MD5(LOWER(TRIM(acc.email)))
)
SELECT
    CASE
        WHEN cm.hashed_email IS NULL THEN 'No CDE match'
        WHEN cm.has_igaming = 0 AND cm.has_icasino = 0 AND cm.has_retail = 1 THEN 'Retail SBK Only'
        WHEN cm.has_igaming = 0 AND cm.has_icasino = 0 AND cm.has_retail = 0 THEN 'No active subledger'
        ELSE 'Has iGaming or iCasino'
    END AS category,
    COUNT(*) AS users
FROM fbg_only_emails f
LEFT JOIN cde_mapped cm ON f.hashed_email = cm.hashed_email
GROUP BY 1
ORDER BY users DESC
