-- Query ID: 01c399ce-0112-6db7-0000-e307218a0086
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:30:03.045000+00:00
-- Elapsed: 103393ms
-- Environment: FES

WITH quarter_data AS (
    SELECT
        period_end AS end_quarter,
        period_label AS quarter_ttm,
        period_start AS start_quarter
    FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
    WHERE period_type = 'quarter'
),

 fbg_fde_activity AS (
        SELECT
            cm."Hashed_Email" AS hashed_email,
            md.start_quarter,
            md.end_quarter,
            md.quarter_ttm,
            CASE WHEN SUM(rev.is_active_day) > 0 THEN TRUE ELSE FALSE END AS is_sportsbook,
            CASE WHEN SUM(rev.oc_active_day) > 0 THEN TRUE ELSE FALSE END AS is_icasino
        FROM FBG_FDE.FBG_TRANSACTIONS.FDE_ACCOUNT_REVENUE_SUMMARY_DAILY AS rev
        INNER JOIN FBG_FDE.FBG_TRANSACTIONS.FDE_CUSTOMER_METRICS AS cm
            ON rev.acco_id = cm.account_id
        INNER JOIN quarter_data AS md
            ON rev.bus_date BETWEEN md.start_quarter AND md.end_quarter
        WHERE md.end_quarter <= LAST_DAY(CURRENT_DATE, 'quarter')
        GROUP BY cm."Hashed_Email", md.start_quarter, md.end_quarter, md.quarter_ttm
    ),

user_source_activity AS (
        SELECT
            emutd.hashed_email,
            md.start_quarter,
            md.end_quarter,
            md.quarter_ttm,
            CASE WHEN emutd.source = 'TOPPS_DIGITAL' THEN 'TOPPS' ELSE emutd.source END AS source,
            COALESCE(fde.is_sportsbook, FALSE) AS is_sportsbook,
            COALESCE(fde.is_icasino, FALSE) AS is_icasino
        FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
        INNER JOIN quarter_data AS md
            ON DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN md.start_quarter AND md.end_quarter
        LEFT JOIN fbg_fde_activity AS fde
            ON emutd.hashed_email = fde.hashed_email
            AND md.quarter_ttm = fde.quarter_ttm
        WHERE md.end_quarter <= LAST_DAY(CURRENT_DATE, 'quarter')
    ),



 user_cohorts_raw AS (
        SELECT
            hashed_email,
            start_quarter,
            end_quarter,
            quarter_ttm,
            ARRAY_AGG(DISTINCT source) AS sources,
            MAX(is_sportsbook) AS is_sportsbook,
            MAX(is_icasino) AS is_icasino
        FROM user_source_activity
        GROUP BY hashed_email, start_quarter, end_quarter, quarter_ttm
    ),


user_cohorts_expanded AS (
    SELECT
        hashed_email,
        start_quarter,
        end_quarter,
        quarter_ttm,
        sources,
        ARRAY_COMPACT(ARRAY_CONSTRUCT(
            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('COMM'::VARIANT, sources), 'Comm Only', NULL),
            IFF(ARRAY_CONTAINS('COMM'::VARIANT, sources), 'Comm All', NULL),

            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('FBG'::VARIANT, sources), 'FBG Only', NULL),
            IFF(ARRAY_CONTAINS('FBG'::VARIANT, sources), 'FBG All', NULL),

            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Collect Only', NULL),
            IFF(ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Collect All', NULL),

            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Live Only', NULL),
            IFF(ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Live All', NULL),

            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('TOPPS'::VARIANT, sources), 'Topps Only', NULL),

            IFF(ARRAY_CONTAINS('TOPPS'::VARIANT, sources), 'Topps All', NULL),


            IFF(ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('FMX'::VARIANT, sources), 'FMX Only', NULL),
            IFF(ARRAY_CONTAINS('FMX'::VARIANT, sources), 'FMX All', NULL),

            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources), 'Comm + FBG Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources), 'Comm + FBG', NULL
            ),

            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Comm + Collect Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Comm + Collect', NULL
            ),

            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FMX'::VARIANT, sources), 'Comm + FMX Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FMX'::VARIANT, sources), 'Comm + FMX', NULL
            ),

            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'FBG + Collect Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'FBG + Collect', NULL
            ),

            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('FMX'::VARIANT, sources), 'FBG + FMX Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('FMX'::VARIANT, sources), 'FBG + FMX', NULL
            ),

            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'COMM + Live', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + Live Only', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'FBG + Live Only', NULL
            ),

            IFF(
                ARRAY_CONTAINS('FMX'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'FMX + Live', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 2
                AND ARRAY_CONTAINS('FMX'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'FMX + Live Only', NULL
            ),

            IFF(
                ARRAY_SIZE(sources) = 3
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Comm + FBG + Collect Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Comm + FBG + Collect', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 3
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + FBG + Live Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + FBG + Live', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 3
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + Collect + Live Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + Collect + Live', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 3
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'FBG + Collect + Live Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'FBG + Collect + Live', NULL
            ),
            IFF(
                ARRAY_SIZE(sources) = 4
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + FBG + Collect + Live Only', NULL
            ),
            IFF(
                ARRAY_CONTAINS('FBG'::VARIANT, sources)
                AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Comm + FBG + Collect + Live', NULL
            ),

 -- Sportsbook single
                IFF(is_sportsbook AND NOT is_icasino AND ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('FBG'::VARIANT, sources), 'Sportsbook Only', NULL),
                IFF(is_sportsbook, 'Sportsbook All', NULL),
    
                -- iCasino single
                IFF(is_icasino AND NOT is_sportsbook AND ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('FBG'::VARIANT, sources), 'iCasino Only', NULL),
                IFF(is_icasino, 'iCasino All', NULL),
    
                -- Sportsbook + iCasino
                IFF(
                    is_sportsbook AND is_icasino
                    AND ARRAY_SIZE(sources) = 1 AND ARRAY_CONTAINS('FBG'::VARIANT, sources),
                    'Sportsbook + iCasino Only', NULL
                ),
                IFF(
                    is_sportsbook AND is_icasino,
                    'Sportsbook + iCasino', NULL
                ),
    
                -- Comm + Sportsbook
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND NOT is_icasino,
                    'Comm + Sportsbook Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND is_sportsbook,
                    'Comm + Sportsbook', NULL
                ),
    
                -- Comm + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino AND NOT is_sportsbook,
                    'Comm + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND is_icasino,
                    'Comm + iCasino', NULL
                ),
    
                -- FBG + Sportsbook
                IFF(
                    ARRAY_SIZE(sources) = 1
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND NOT is_icasino,
                    'FBG + Sportsbook Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook,
                    'FBG + Sportsbook', NULL
                ),
    
                -- FBG + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 1
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino AND NOT is_sportsbook,
                    'FBG + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino,
                    'FBG + iCasino', NULL
                ),
    
                -- Collect + Sportsbook
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND NOT is_icasino,
                    'Collect + Sportsbook Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND is_sportsbook,
                    'Collect + Sportsbook', NULL
                ),
    
                -- Collect + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino AND NOT is_sportsbook,
                    'Collect + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND is_icasino,
                    'Collect + iCasino', NULL
                ),
    
                -- Comm + FBG + Sportsbook
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND NOT is_icasino,
                    'Comm + FBG + Sportsbook Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook,
                    'Comm + FBG + Sportsbook', NULL
                ),
    
                -- Comm + FBG + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino AND NOT is_sportsbook,
                    'Comm + FBG + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_icasino,
                    'Comm + FBG + iCasino', NULL
                ),
    
                -- Comm + Sportsbook + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Comm + Sportsbook + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Comm + Sportsbook + iCasino', NULL
                ),
    
                -- FBG + Sportsbook + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 1
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'FBG + Sportsbook + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'FBG + Sportsbook + iCasino', NULL
                ),
    
                -- Collect + Sportsbook + iCasino
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Collect + Sportsbook + iCasino Only', NULL
                ),
                IFF(
                    ARRAY_CONTAINS('COLL'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Collect + Sportsbook + iCasino', NULL
                ),
    
                -- Comm + FBG + Sportsbook + iCasino (4-way)
                IFF(
                    ARRAY_SIZE(sources) = 2
                    AND ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Comm + FBG + Sportsbook + iCasino Only', NULL
                ),

                IFF(
        ARRAY_SIZE(sources) = 2
        AND ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Topps + Live Only', NULL
    ),
    IFF(
        ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Topps + Live', NULL
    ),

    IFF(
        ARRAY_SIZE(sources) = 2
        AND ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Topps + Collect Only', NULL
    ),
    IFF(
        ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Topps + Collect', NULL
    ),

    IFF(
        ARRAY_SIZE(sources) = 2
        AND ARRAY_CONTAINS('LIVE'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Live + Collect Only', NULL
    ),
    IFF(
        ARRAY_CONTAINS('LIVE'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources), 'Live + Collect', NULL
    ),

     IFF(
        ARRAY_SIZE(sources) = 3
        AND ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
        AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Topps + Collect + Live Only', NULL
    ),
    IFF(
        ARRAY_CONTAINS('TOPPS'::VARIANT, sources)
        AND ARRAY_CONTAINS('COLL'::VARIANT, sources)
        AND ARRAY_CONTAINS('LIVE'::VARIANT, sources), 'Topps + Collect + Live', NULL
    ),
                IFF(
                    ARRAY_CONTAINS('COMM'::VARIANT, sources)
                    AND ARRAY_CONTAINS('FBG'::VARIANT, sources)
                    AND is_sportsbook AND is_icasino,
                    'Comm + FBG + Sportsbook + iCasino', NULL
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
        e.sources,
        f.value::STRING AS opco_group
    FROM user_cohorts_expanded AS e,
        LATERAL FLATTEN(input => e.opco_labels) AS f
),

--include null-email revenue in single-opco totals for everything besides commerce
aggregated_metrics_single_opco AS (
    SELECT
        uc.opco_group AS opco,
        uc.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / COUNT(DISTINCT emutd.hashed_email) AS arpu,
        SUM(emutd.total_revenue) / SUM(emutd.total_transaction_count) AS aov,
        SUM(emutd.total_transaction_count) / COUNT(DISTINCT emutd.hashed_email) AS transaction_per_fan
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN user_cohorts AS uc
        ON
            NOT CONTAINS(uc.opco_group, '+')
            AND COALESCE(emutd.hashed_email, '') = COALESCE(uc.hashed_email, '')
            AND DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN uc.start_quarter AND uc.end_quarter
     WHERE
            (
                uc.opco_group = 'Comm All' AND emutd.tenant_id = '100001'
            )
            OR (
                uc.opco_group = 'FBG All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
            )
            OR (
                uc.opco_group = 'Collect All' AND emutd.tenant_id = '100004' AND emutd.source = 'COLL'
            )
            OR (
                uc.opco_group = 'Topps All' AND emutd.tenant_id = '100004' AND emutd.source in ('TOPPS','TOPPS_DIGITAL')
            )
            OR (
                uc.opco_group = 'Live All' AND emutd.tenant_id = '100004' AND emutd.source = 'LIVE'
            )
            OR (
                uc.opco_group = 'FMX All' AND emutd.tenant_id = '100002' AND emutd.source = 'FMX'
            )
            OR (
                uc.opco_group = 'Sportsbook All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
            )
            OR (
                uc.opco_group = 'iCasino All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
            )
             OR (
                uc.opco_group = 'Topps Only' AND emutd.tenant_id = '100004' AND emutd.source IN ('TOPPS', 'TOPPS_DIGITAL')
            )
            OR (
                uc.opco_group NOT IN ('Comm All', 'FBG All', 'Collect All', 'Topps All', 'Topps Only','Live All', 'FMX All', 'Sportsbook All', 'iCasino All')
            )
    GROUP BY uc.opco_group, uc.quarter_ttm
),

--exclude null-email users from cross-opco cohorts because we can’t prove they’re the same person
--same goes for comm because commerce does not include marketplace in either revenue total
aggregated_metrics_cross_opco AS (
    SELECT
        uc.opco_group AS opco,
        uc.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / COUNT(DISTINCT emutd.hashed_email) AS arpu,
        SUM(emutd.total_revenue) / SUM(emutd.total_transaction_count) AS aov,
        SUM(emutd.total_transaction_count) / COUNT(DISTINCT emutd.hashed_email) AS transaction_per_fan
    FROM ENTERPRISE_METRICS.REPORTING.BASE_EM_USER_TXN_WITH_FC_SNAPSHOT AS emutd
    INNER JOIN user_cohorts AS uc
        ON
            CONTAINS(uc.opco_group, '+')
            AND emutd.hashed_email = uc.hashed_email
            AND DATEFROMPARTS(emutd.year, emutd.month, 1) BETWEEN uc.start_quarter AND uc.end_quarter
    WHERE
        (
            uc.opco_group = 'Comm All' AND emutd.tenant_id = '100001'
        )
        OR (
            uc.opco_group = 'FBG All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
        )
        OR (
            uc.opco_group = 'Collect All' AND emutd.tenant_id = '100004' AND emutd.source = 'COLL'
        )
        OR (
        uc.opco_group = 'Topps All' AND emutd.tenant_id = '100004' AND emutd.source IN ('TOPPS', 'TOPPS_DIGITAL')
    )
        OR (
            uc.opco_group = 'Live All' AND emutd.tenant_id = '100004' AND emutd.source = 'LIVE'
        )
        OR (
            uc.opco_group = 'FMX All' AND emutd.tenant_id = '100002' AND emutd.source = 'FMX'
        )
        OR (
            uc.opco_group NOT IN ('Comm All', 'FBG All', 'Collect All', 'Topps All', 'Live All', 'FMX All','Sportsbook All', 'iCasino All')
        )
        OR (
                uc.opco_group = 'Sportsbook All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
            )
            OR (
                uc.opco_group = 'iCasino All' AND emutd.tenant_id = '100002' AND emutd.source = 'FBG'
            )

    GROUP BY uc.opco_group, uc.quarter_ttm
),

any_vertical AS (
    SELECT
        'Any Vertical' AS opco,
        md.quarter_ttm,
        COUNT(DISTINCT emutd.hashed_email) AS fan_count,
        SUM(emutd.total_revenue) AS total_revenue,
        SUM(emutd.total_transaction_count) AS transaction_count,
        SUM(emutd.total_revenue) / COUNT(DISTINCT emutd.hashed_email) AS arpu,
        SUM(emutd.total_revenue) / SUM(emutd.total_transaction_count) AS aov,
        SUM(emutd.total_transaction_count) / COUNT(DISTINCT emutd.hashed_email) AS transaction_per_fan
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
