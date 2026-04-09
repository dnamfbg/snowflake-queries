-- Query ID: 01c39a3e-0212-6cb9-24dd-07031942f593
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:29.508000+00:00
-- Elapsed: 2241ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_monthly_forecasts
    
    
    
    as (WITH report_dates AS ( --noqa: disable=all
    SELECT DISTINCT report_date
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_dashboard
),

month_calendar AS (
    SELECT
        rd.report_date,
        cal.date_id_alk AS activity_date
    FROM report_dates AS rd
    INNER JOIN FMX_ANALYTICS.DIMENSIONS.dim_date AS cal
        ON
            cal.date_id_alk BETWEEN DATE_TRUNC('month', rd.report_date)
            AND DATEADD(DAY, -1, DATEADD(MONTH, 1, DATE_TRUNC('month', rd.report_date)))
),

actuals AS (
    SELECT
        activity_date,
        revenue_amt AS actual_revenue_usd,
        fmx_ftus AS actual_ftus,
        actives AS actual_actives
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_dashboard
),

forecasts AS (
    SELECT
        total_revenue_usd AS forecast_revenue_usd,
        total_ftus AS forecast_ftus,
        actives AS forecast_actives,
        CAST(date AS DATE) AS activity_date
    FROM FMX_ANALYTICS.STAGING.fmx_forecasts
),

joined AS (
    SELECT
        mc.report_date,
        mc.activity_date,
        COALESCE(act.actual_revenue_usd, 0) AS actual_revenue_usd,
        COALESCE(fc.forecast_revenue_usd, 0) AS forecast_revenue_usd,
        COALESCE(act.actual_ftus, 0) AS actual_ftus,
        COALESCE(fc.forecast_ftus, 0) AS forecast_ftus,
        COALESCE(act.actual_actives, 0) AS actual_actives,
        COALESCE(fc.forecast_actives, 0) AS forecast_actives
    FROM month_calendar AS mc
    LEFT JOIN actuals AS act
        ON mc.activity_date = act.activity_date
    LEFT JOIN forecasts AS fc
        ON mc.activity_date = fc.activity_date
),

cumulative AS (
    SELECT
        report_date,
        activity_date,
        SUM(actual_revenue_usd) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS actual_revenue_usd,
        SUM(forecast_revenue_usd) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS forecast_revenue_usd,
        SUM(actual_ftus) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS actual_ftus,
        SUM(forecast_ftus) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS forecast_ftus,
        SUM(actual_actives) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS actual_actives,
        SUM(forecast_actives) OVER (
            PARTITION BY report_date
            ORDER BY activity_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS forecast_actives
    FROM joined
)

SELECT
    report_date,
    activity_date,
    actual_revenue_usd,
    forecast_revenue_usd,
    actual_ftus,
    forecast_ftus,
    actual_actives,
    forecast_actives
FROM cumulative
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_monthly_forecasts", "profile_name": "user", "target_name": "default"} */
