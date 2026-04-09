-- Query ID: 01c39a3b-0212-67a8-24dd-070319424767
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:19:19.036000+00:00
-- Elapsed: 186470ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.int_fmx_daily_customer_activity
    
    
    
    as (WITH date_bounds AS ( --noqa: disable=all
    SELECT
        MIN(created_date_alk) AS min_date,
        CURRENT_DATE AS max_date
    FROM FMX_ANALYTICS.STAGING.stg_fmx_account_segments
    WHERE created_date_alk IS NOT NULL
),

calendar AS (
    SELECT d.date_id_alk AS report_date
    FROM FMX_ANALYTICS.DIMENSIONS.dim_date AS d
    CROSS JOIN date_bounds AS b
    WHERE d.date_id_alk BETWEEN b.min_date AND b.max_date
),

account_first_logins AS (
    SELECT
        acco_id,
        MIN(CASE WHEN enterprise_product = 'FMX' THEN created_at_alk END) AS fmx_first_login_alk,
        MIN(CASE WHEN enterprise_product = 'FBG' THEN created_at_alk END) AS fbg_first_login_alk
    FROM FMX_ANALYTICS.STAGING.stg_fmx_account_segments
    GROUP BY 1
),

account_classification AS (
    SELECT
        afl.acco_id,
        afl.fmx_first_login_alk,
        afl.fbg_first_login_alk,
        COALESCE(acc.is_test_account, 0) AS is_test_account,
        CASE
            WHEN afl.fmx_first_login_alk IS NOT NULL AND afl.fbg_first_login_alk IS NOT NULL THEN 'FBG/FMX'
            WHEN afl.fmx_first_login_alk IS NOT NULL THEN 'FMX'
            WHEN afl.fbg_first_login_alk IS NOT NULL THEN 'FBG'
            ELSE 'UNKNOWN'
        END AS enterprise_product_flag
    FROM account_first_logins AS afl
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_accounts AS acc
        ON afl.acco_id = acc.acco_id
),

daily_new_customers AS (
    SELECT
        DATE(fmx_first_login_alk) AS report_date,
        COUNT(DISTINCT CASE WHEN enterprise_product_flag IN ('FMX', 'FBG/FMX') THEN acco_id END) AS new_customers_count,
        COUNT(DISTINCT CASE WHEN enterprise_product_flag = 'FMX' THEN acco_id END) AS new_non_fbg_customer_count,
        COUNT(DISTINCT CASE WHEN enterprise_product_flag = 'FBG/FMX' THEN acco_id END)
            AS new_both_fbg_fmx_customer_count
    FROM account_classification
    WHERE
        fmx_first_login_alk IS NOT NULL
        AND COALESCE(is_test_account, 0) = 0
    GROUP BY 1
),

daily_ftu AS (
    SELECT
        DATE(fmx_ftu_date_alk) AS report_date,
        COUNT(DISTINCT ftu.acco_id) AS fmx_ftus
    FROM FMX_ANALYTICS.CUSTOMER.fmx_first_time_users AS ftu
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_accounts AS acc
        ON ftu.acco_id = acc.acco_id
    WHERE
        ftu.fmx_ftu_date_alk IS NOT NULL
        AND COALESCE(acc.is_test_account, 0) = 0
    GROUP BY 1
),

ftu_channel_groups AS (
    SELECT
        ftu.acco_id,
        DATE(ftu.fmx_ftu_date_alk) AS report_date,
        acq.channel_group
    FROM FMX_ANALYTICS.CUSTOMER.fmx_first_time_users AS ftu
    LEFT JOIN FMX_ANALYTICS.CUSTOMER.int_fmx_acquisition_customer AS acq
        ON ftu.acco_id = acq.acco_id
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_accounts AS acc
        ON ftu.acco_id = acc.acco_id
    WHERE
        ftu.fmx_ftu_date_alk IS NOT NULL
        AND COALESCE(acc.is_test_account, 0) = 0
),

ftu_by_channel AS (
    SELECT
        report_date,
        COUNT(DISTINCT CASE WHEN channel_group = 'ORGANIC' THEN acco_id END) AS fmx_ftus_organic,
        COUNT(DISTINCT CASE WHEN channel_group = 'PERFORMANCE' THEN acco_id END) AS fmx_ftus_performance,
        COUNT(DISTINCT CASE WHEN channel_group = 'OTHER' THEN acco_id END) AS fmx_ftus_other
    FROM ftu_channel_groups
    GROUP BY 1
)

SELECT
    cal.report_date,
    COALESCE(ftu.fmx_ftus, 0) AS fmx_ftus,
    COALESCE(ftc.fmx_ftus_organic, 0) AS fmx_ftus_organic,
    COALESCE(ftc.fmx_ftus_performance, 0) AS fmx_ftus_performance,
    COALESCE(ftc.fmx_ftus_other, 0) AS fmx_ftus_other,
    COALESCE(nc.new_customers_count, 0) AS new_customers_count,
    COALESCE(nc.new_customers_count, 0) AS new_customers_total,
    COALESCE(nc.new_non_fbg_customer_count, 0) AS new_non_fbg_customer_count,
    COALESCE(nc.new_non_fbg_customer_count, 0) AS non_fbg_customer_login_count,
    COALESCE(nc.new_both_fbg_fmx_customer_count, 0) AS new_both_fbg_fmx_customer_count,
    COALESCE(nc.new_both_fbg_fmx_customer_count, 0) AS new_fbg_customer_login_count
FROM calendar AS cal
LEFT JOIN daily_ftu AS ftu
    ON cal.report_date = ftu.report_date
LEFT JOIN daily_new_customers AS nc
    ON cal.report_date = nc.report_date
LEFT JOIN ftu_by_channel AS ftc
    ON cal.report_date = ftc.report_date
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.int_fmx_daily_customer_activity", "profile_name": "user", "target_name": "default"} */
