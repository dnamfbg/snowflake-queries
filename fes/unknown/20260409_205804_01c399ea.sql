-- Query ID: 01c399ea-0112-6bf9-0000-e3072189fc1a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:58:04.068000+00:00
-- Elapsed: 66821ms
-- Environment: FES

WITH quarter_data AS (
    SELECT
        period_end AS end_quarter,
        period_label AS quarter_ttm,
        period_start AS start_quarter
    FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
    WHERE period_type = 'quarter'
),

-- CDE vertical flags per customer per month
cde_vertical AS (
    SELECT
        customer_id,
        YEAR(bus_date) AS yr,
        MONTH(bus_date) AS mo,
        MAX(IFF(active_flag AND subledger_application = 'iGaming', 1, 0)) AS has_igaming,
        MAX(IFF(active_flag AND subledger_application = 'iCasino', 1, 0)) AS has_icasino
    FROM CDE.CDE_CORE.TOTAL_REVENUE
    WHERE bus_date >= '2023-01-01'
      AND active_flag = TRUE
    GROUP BY customer_id, YEAR(bus_date), MONTH(bus_date)
),

-- Map customer_id to hashed_email (same as dbt model)
cde_with_email AS (
    SELECT
        cv.yr,
        cv.mo,
        MD5(LOWER(TRIM(acc.email))) AS hashed_email,
        cv.has_igaming,
        cv.has_icasino
    FROM cde_vertical cv
    INNER JOIN FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS acc ON cv.customer_id = acc.id
    WHERE acc.email IS NOT NULL
),

user_tenant_activity AS (
    SELECT
        emutd.hashed_email,
        md.start_quarter,
        md.end_quarter,
        md.quarter_ttm,
        emutd.tenant_id
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN quarter_data AS md
        ON DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN md.start_quarter AND md.end_quarter
    WHERE md.end_quarter <= LAST_DAY(CURRENT_DATE, 'quarter')
),

user_cohorts_raw AS (
    SELECT
        hashed_email,
        start_quarter,
        end_quarter,
        quarter_ttm,
        ARRAY_AGG(DISTINCT tenant_id::NUMBER) AS tenant_ids
    FROM user_tenant_activity
    GROUP BY hashed_email, start_quarter, end_quarter, quarter_ttm
),

-- Roll up CDE vertical flags to TTM period level
cde_ttm AS (
    SELECT
        ce.hashed_email,
        md.start_quarter,
        md.end_quarter,
        MAX(ce.has_igaming) AS is_sportsbook,
        MAX(ce.has_icasino) AS is_icasino
    FROM cde_with_email ce
    INNER JOIN quarter_data md
        ON DATEFROMPARTS(ce.yr, ce.mo, 1) BETWEEN md.start_quarter AND md.end_quarter
    WHERE md.end_quarter <= LAST_DAY(CURRENT_DATE, 'quarter')
    GROUP BY ce.hashed_email, md.start_quarter, md.end_quarter
),

user_cohorts_expanded AS (
    SELECT
        ucr.hashed_email,
        ucr.start_quarter,
        ucr.end_quarter,
        ucr.quarter_ttm,
        ucr.tenant_ids,
        ARRAY_COMPACT(ARRAY_CONSTRUCT(
            -- Existing labels
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids), 'Comm Only', NULL),
            IFF(ARRAY_CONTAINS(100001::VARIANT, tenant_ids), 'Comm All', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'FBG Only', NULL),
            IFF(ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'FBG All', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Collectibles Only', NULL),
            IFF(ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Collectibles All', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 2 AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'Comm + FBG Only', NULL),
            IFF(ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'Comm + FBG', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 2 AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + Collectibles Only', NULL),
            IFF(ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + Collectibles', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 2 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'FBG + Collectibles Only', NULL),
            IFF(ARRAY_CONTAINS(100002::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'FBG + Collectibles', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 3 AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + FBG + Collectibles Only', NULL),
            IFF(ARRAY_CONTAINS(100001::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids) AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + FBG + Collectibles', NULL),

            -- New SBK/Casino labels (FBG Only users only)
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                AND COALESCE(ct.is_sportsbook, 0) = 1 AND COALESCE(ct.is_icasino, 0) = 0, 'SBK Only', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                AND COALESCE(ct.is_sportsbook, 0) = 0 AND COALESCE(ct.is_icasino, 0) = 1, 'Casino Only', NULL),
            IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                AND COALESCE(ct.is_sportsbook, 0) = 1 AND COALESCE(ct.is_icasino, 0) = 1, 'SBK + Casino', NULL)
        )) AS opco_labels
    FROM user_cohorts_raw ucr
    LEFT JOIN cde_ttm ct
        ON ucr.hashed_email = ct.hashed_email
        AND ucr.start_quarter = ct.start_quarter
        AND ucr.end_quarter = ct.end_quarter
),

user_cohorts AS (
    SELECT
        e.hashed_email,
        e.start_quarter,
        e.end_quarter,
        e.quarter_ttm,
        e.tenant_ids,
        f.value::STRING AS opco_group
    FROM user_cohorts_expanded AS e,
        LATERAL FLATTEN(input => e.opco_labels) AS f
),

aggregated_metrics_single_opco AS (
    SELECT
        uc.opco_group AS opco,
        uc.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS arpu,
        SUM(emutd.total_revenue) / NULLIF(SUM(emutd.total_transaction_count), 0) AS aov,
        SUM(emutd.total_transaction_count) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS transaction_per_fan
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN user_cohorts AS uc
        ON
            NOT CONTAINS(uc.opco_group, '+') AND uc.opco_group <> 'Comm All' AND uc.opco_group <> 'Comm Only'
            AND COALESCE(emutd.hashed_email, '') = COALESCE(uc.hashed_email, '')
            AND DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN uc.start_quarter AND uc.end_quarter
    WHERE
        (uc.opco_group = 'FBG Only' AND emutd.tenant_id = '100002')
        OR (uc.opco_group = 'FBG All' AND emutd.tenant_id = '100002')
        OR (uc.opco_group = 'Collectibles Only' AND emutd.tenant_id = '100004')
        OR (uc.opco_group = 'Collectibles All' AND emutd.tenant_id = '100004')
        OR (uc.opco_group = 'SBK Only' AND emutd.tenant_id = '100002')
        OR (uc.opco_group = 'Casino Only' AND emutd.tenant_id = '100002')
        OR (uc.opco_group = 'SBK + Casino' AND emutd.tenant_id = '100002')
    GROUP BY uc.opco_group, uc.quarter_ttm
),

aggregated_metrics_cross_opco AS (
    SELECT
        uc.opco_group AS opco,
        uc.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS arpu,
        SUM(emutd.total_revenue) / NULLIF(SUM(emutd.total_transaction_count), 0) AS aov,
        SUM(emutd.total_transaction_count) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS transaction_per_fan
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN user_cohorts AS uc
        ON
            (CONTAINS(uc.opco_group, '+') OR uc.opco_group = 'Comm All' OR uc.opco_group = 'Comm Only')
            AND emutd.hashed_email = uc.hashed_email
            AND DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN uc.start_quarter AND uc.end_quarter
    WHERE
        (uc.opco_group = 'Comm All' AND emutd.tenant_id = '100001')
        OR (uc.opco_group = 'Comm Only' AND emutd.tenant_id = '100001')
        OR (uc.opco_group IN ('Comm + FBG Only', 'Comm + FBG'))
        OR (uc.opco_group IN ('Comm + Collectibles Only', 'Comm + Collectibles') AND emutd.tenant_id IN ('100001', '100004'))
        OR (uc.opco_group IN ('FBG + Collectibles Only', 'FBG + Collectibles') AND emutd.tenant_id IN ('100002', '100004'))
        OR (uc.opco_group IN ('Comm + FBG + Collectibles Only', 'Comm + FBG + Collectibles'))
        OR (uc.opco_group = 'SBK + Casino' AND emutd.tenant_id = '100002')
    GROUP BY uc.opco_group, uc.quarter_ttm
),

any_vertical AS (
    SELECT
        'Any Vertical' AS opco,
        md.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS arpu,
        SUM(emutd.total_revenue) / NULLIF(SUM(emutd.total_transaction_count), 0) AS aov,
        SUM(emutd.total_transaction_count) / NULLIF(COUNT(DISTINCT emutd.hashed_email), 0) AS transaction_per_fan
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN quarter_data AS md
        ON DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN md.start_quarter AND md.end_quarter
    WHERE md.end_quarter <= LAST_DAY(CURRENT_DATE, 'quarter')
    GROUP BY md.quarter_ttm
)

SELECT * FROM aggregated_metrics_single_opco
UNION ALL
SELECT * FROM aggregated_metrics_cross_opco
UNION ALL
SELECT * FROM any_vertical
ORDER BY opco, quarter_ttm
