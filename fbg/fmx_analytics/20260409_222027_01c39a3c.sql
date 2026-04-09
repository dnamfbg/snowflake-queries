-- Query ID: 01c39a3c-0212-67a8-24dd-070319424d97
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:20:27.078000+00:00
-- Elapsed: 2176ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.PRODUCT.fct_fmx_product_acquisition_daily
    
    
    
    as (WITH daily AS (
    SELECT
        date AS activity_date,
        DATEADD('day', 1, date) AS report_date,
        SUM(install_count) AS install_count,
        SUM(registration_count) AS registration_count,
        SUM(ftd_count) AS ftd_count,
        SUM(ftu_count) AS ftu_count
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_acquisition_summary_daily
    GROUP BY date
),

with_rollups AS (
    SELECT
        *,
        SUM(install_count) OVER (ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS install_count_7d,
        SUM(registration_count)
            OVER (ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
            AS registration_count_7d,
        SUM(ftd_count) OVER (ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ftd_count_7d,
        SUM(ftu_count) OVER (ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS ftu_count_7d
    FROM daily
)

SELECT
    activity_date,
    report_date,
    install_count,
    registration_count,
    ftd_count,
    ftu_count,
    install_count_7d,
    registration_count_7d,
    ftd_count_7d,
    ftu_count_7d
FROM with_rollups
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_product_acquisition_daily", "profile_name": "user", "target_name": "default"} */
