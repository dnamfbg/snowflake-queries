-- Query ID: 01c399c5-0112-6be5-0000-e30721893cc2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:21:39.493000+00:00
-- Elapsed: 24100ms
-- Environment: FES

WITH month_series AS (
    SELECT DATEADD('month', seq4(), '2024-01-01'::DATE) AS month_start
    FROM TABLE(GENERATOR(ROWCOUNT => 27))
    WHERE DATEADD('month', seq4(), '2024-01-01'::DATE) <= '2026-03-01'
),
ttm_periods AS (
    SELECT
        month_start AS period_end_month,
        DATEADD('month', -11, month_start) AS period_start_month
    FROM month_series
    WHERE DATEADD('month', -11, month_start) >= '2024-01-01'
),
computed_revenue AS (
    SELECT
        customer_id,
        YEAR(bus_date) AS yr,
        MONTH(bus_date) AS mo,
        MAX(IFF(active_flag AND subledger_application = 'iGaming', 1, 0)) AS has_igaming,
        MAX(IFF(active_flag AND subledger_application = 'iCasino', 1, 0)) AS has_icasino,
        MAX(IFF(active_flag, 1, 0)) AS has_wagers
    FROM CDE.CDE_CORE.TOTAL_REVENUE
    WHERE bus_date >= '2024-01-01'
    GROUP BY customer_id, YEAR(bus_date), MONTH(bus_date)
),
with_email AS (
    SELECT
        rev.customer_id,
        rev.yr,
        rev.mo,
        CASE WHEN rev.has_wagers = 1 THEN MD5(LOWER(TRIM(acc.email))) END AS hashed_email,
        rev.has_igaming,
        rev.has_icasino
    FROM computed_revenue rev
    LEFT JOIN FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS acc ON rev.customer_id = acc.id
    WHERE rev.has_wagers = 1
      AND MD5(LOWER(TRIM(acc.email))) IS NOT NULL
),
other_opco AS (
    SELECT DISTINCT hashed_email, year, month
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT
    WHERE tenant_id != '100002'
      AND year >= 2024
      AND hashed_email IS NOT NULL
),
fbg_only AS (
    SELECT w.*
    FROM with_email w
    LEFT JOIN other_opco o
        ON w.hashed_email = o.hashed_email
        AND w.yr = o.year
        AND w.mo = o.month
    WHERE o.hashed_email IS NULL
),
ttm_users AS (
    SELECT
        t.period_end_month,
        f.hashed_email,
        MAX(f.has_igaming) AS has_igaming,
        MAX(f.has_icasino) AS has_icasino
    FROM ttm_periods t
    INNER JOIN fbg_only f
        ON DATEFROMPARTS(f.yr, f.mo, 1) BETWEEN t.period_start_month AND t.period_end_month
    GROUP BY t.period_end_month, f.hashed_email
)
SELECT
    YEAR(period_end_month) AS yr,
    MONTH(period_end_month) AS mo,
    TO_CHAR(period_end_month, 'MON YY') AS ttm_ending,
    CASE
        WHEN has_igaming = 1 AND has_icasino = 1 THEN 'Both'
        WHEN has_igaming = 1 THEN 'SBK Only'
        WHEN has_icasino = 1 THEN 'Casino Only'
    END AS category,
    COUNT(DISTINCT hashed_email) AS users
FROM ttm_users
GROUP BY period_end_month, yr, mo, ttm_ending, category
ORDER BY period_end_month, category
