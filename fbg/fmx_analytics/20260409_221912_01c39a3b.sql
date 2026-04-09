-- Query ID: 01c39a3b-0212-67a9-24dd-0703194257ff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:19:12.095000+00:00
-- Elapsed: 5568ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.int_fmx_acquisition_customer
    
    
    
    as (WITH fmx_acq_customers_before_recategorization AS ( --noqa: disable=all
    SELECT
        cfa.acco_id,
        cfa.is_test,
        acq.appsflyer_id,
        acq.platform,
        acq.install_date_alk,
        cfa.reg_state,
        cfa.reg_date,
        cfa.fmx_first_login_date,
        cfa.first_enterprise_product,
        cfa.kyc_date,
        cfa.first_fmx_deposit_amount,
        cfa.first_fmx_deposit_jurisdiction_code,
        cfa.first_fmx_deposit_date_alk,
        cfa.second_fmx_deposit_amount,
        cfa.second_fmx_deposit_jurisdiction_code,
        cfa.second_fmx_deposit_date_alk,
        cfa.first_fmx_order_amount,
        cfa.first_fmx_order_jurisdiction_code,
        cfa.first_fmx_order_date_alk,
        cfa.second_fmx_order_amount,
        cfa.second_fmx_order_jurisdiction_code,
        cfa.second_fmx_use_date_alk,
        cfa.week_1_order_buy_count,
        cfa.reg_14_days_order_buy_count,
        cfa.month_1_order_buy_count,
        cfa.week_1_order_buys,
        cfa.week_2_order_buys,
        cfa.month_1_order_buys,
        cfa.month_2_order_buys,
        COALESCE(acq.partner, 'untracked') AS partner,
        COALESCE(acq.subpartner, 'untracked') AS subpartner,
        COALESCE(acq.media_source, 'untracked') AS media_source,
        COALESCE(acq.campaign, 'untracked') AS campaign,
        MD5(
            CONCAT(
                COALESCE(acq.partner, 'untracked'),
                COALESCE(acq.subpartner, 'untracked'),
                COALESCE(acq.media_source, 'untracked'),
                COALESCE(acq.campaign, 'untracked')
            )
        ) AS acquisition_id,
        CASE WHEN cfa.week_1_order_buy_count >= 2 THEN 'Y' ELSE 'N' END AS over_2_orders_first_week_flag,
        CASE WHEN cfa.reg_14_days_order_buy_count >= 4 THEN 'Y' ELSE 'N' END AS over_4_orders_first_14_days_flag,
        CASE WHEN cfa.month_1_order_buy_count >= 8 THEN 'Y' ELSE 'N' END AS over_8_orders_first_month_flag,
        DATEDIFF(DAY, DATE(acq.install_date_alk), DATE(cfa.first_fmx_order_date_alk)) AS install_to_ftu_days,
        DATEDIFF(DAY, DATE(cfa.reg_date), DATE(cfa.first_fmx_order_date_alk)) AS reg_to_ftu_days
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_customer_first_activity AS cfa
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_customer_acq AS acq
        ON cfa.acco_id = acq.acco_id
),

recategorizations AS (
    SELECT
        a.l59i0nddqf AS partner_raw,
        lulpvw8bf5 AS partner_transform,
        ui02sbnhhr AS channel_subgroup
    FROM FMX_ANALYTICS.SIGMA_FMX."SIGDS_62bc0bee_1e35_4917_aa69_02532a690a13" AS a
    INNER JOIN (
        SELECT
            l59i0nddqf,
            MAX(row_version) AS max_row
        FROM FMX_ANALYTICS.SIGMA_FMX."SIGDS_62bc0bee_1e35_4917_aa69_02532a690a13"
        GROUP BY ALL
    ) AS b
        ON a.l59i0nddqf = b.l59i0nddqf AND a.row_version = b.max_row

    GROUP BY ALL
),

fmx_acq_customers AS (
    SELECT
        acco_id,
        is_test,
        appsflyer_id,
        platform,
        install_date_alk,
        reg_state,
        reg_date,
        fmx_first_login_date,
        first_enterprise_product,
        kyc_date,
        first_fmx_deposit_amount,
        first_fmx_deposit_jurisdiction_code,
        first_fmx_deposit_date_alk,
        second_fmx_deposit_amount,
        second_fmx_deposit_jurisdiction_code,
        second_fmx_deposit_date_alk,
        first_fmx_order_amount,
        first_fmx_order_jurisdiction_code,
        first_fmx_order_date_alk,
        second_fmx_order_amount,
        second_fmx_order_jurisdiction_code,
        second_fmx_use_date_alk,
        week_1_order_buy_count,
        reg_14_days_order_buy_count,
        month_1_order_buy_count,
        week_1_order_buys,
        week_2_order_buys,
        month_1_order_buys,
        month_2_order_buys,
        subpartner,
        media_source,
        campaign,
        acquisition_id,
        over_2_orders_first_week_flag,
        over_4_orders_first_14_days_flag,
        over_8_orders_first_month_flag,
        install_to_ftu_days,
        reg_to_ftu_days,
        channel_subgroup,
        COALESCE(b.partner_transform, a.partner) AS partner

    FROM fmx_acq_customers_before_recategorization AS a
    LEFT JOIN recategorizations AS b
        ON a.partner = b.partner_raw

    GROUP BY ALL
)

SELECT
    *,
    CASE
        WHEN LOWER(channel_subgroup) IN (
            'paid social', 'paid search', 'affiliates', 'app networks'
        ) THEN 'PERFORMANCE'
        WHEN LOWER(channel_subgroup) = 'organic' THEN 'ORGANIC'
        WHEN LOWER(COALESCE(channel_subgroup, media_source, '')) = '' THEN 'ORGANIC'
        ELSE 'OTHER'
    END AS channel_group
FROM fmx_acq_customers
WHERE COALESCE(is_test, 0) = 0
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.int_fmx_acquisition_customer", "profile_name": "user", "target_name": "default"} */
