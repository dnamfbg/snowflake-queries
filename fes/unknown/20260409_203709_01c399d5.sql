-- Query ID: 01c399d5-0112-6f44-0000-e307218a2056
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:37:09.123000+00:00
-- Elapsed: 45166ms
-- Environment: FES

WITH quarter_data AS (
        SELECT
            period_end AS end_quarter,
            period_label AS quarter_ttm,
            period_start AS start_quarter
        FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
        WHERE period_type = 'quarter'
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

    user_cohorts_expanded AS (
        SELECT
            hashed_email,
            start_quarter,
            end_quarter,
            quarter_ttm,
            tenant_ids,
            ARRAY_COMPACT(ARRAY_CONSTRUCT(
                IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids), 'Comm Only', NULL),
                IFF(ARRAY_CONTAINS(100001::VARIANT, tenant_ids), 'Comm All', NULL),

                IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'FBG Only', NULL),
                IFF(ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'FBG All', NULL),

                IFF(ARRAY_SIZE(tenant_ids) = 1 AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Collectibles Only', NULL),
                IFF(ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Collectibles All', NULL),

                IFF(
                    ARRAY_SIZE(tenant_ids) = 2
                    AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'Comm + FBG Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids), 'Comm + FBG', NULL
                ),

                IFF(
                    ARRAY_SIZE(tenant_ids) = 2
                    AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + Collectibles Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + Collectibles', NULL
                ),

                IFF(
                    ARRAY_SIZE(tenant_ids) = 2
                    AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'FBG + Collectibles Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'FBG + Collectibles', NULL
                ),

                IFF(
                    ARRAY_SIZE(tenant_ids) = 3
                    AND ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + FBG + Collectibles Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS(100001::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100002::VARIANT, tenant_ids)
                    AND ARRAY_CONTAINS(100004::VARIANT, tenant_ids), 'Comm + FBG + Collectibles', NULL
                )
            )) AS opco_labels
        FROM user_cohorts_raw
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
    SELECT * FROM any_vertical;
