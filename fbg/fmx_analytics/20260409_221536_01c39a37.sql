-- Query ID: 01c39a37-0212-67a9-24dd-070319416e67
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:15:36.452000+00:00
-- Elapsed: 72943ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_tier_points
    
    
    
    as (WITH params AS (

    SELECT
        '2026-03-01'::DATE AS program_start,
        DATEADD(
            'day',
            MOD(2 - DAYOFWEEK('2026-03-01'::DATE) + 7, 7),
            '2026-03-01'::DATE
        ) AS first_tuesday

),

period_spine_raw AS (

    -- Partial opening period: program start through the day before the first Tuesday
    -- Only included when program start is not itself a Tuesday
    SELECT
        0 AS seq_num,
        p.program_start AS period_start_date,
        DATEADD('day', -1, p.first_tuesday) AS period_end_date
    FROM params AS p
    WHERE p.first_tuesday > p.program_start

    UNION ALL

    -- Full Tue-Mon weekly periods from the first Tuesday onwards
    SELECT
        ROW_NUMBER() OVER (ORDER BY SEQ4()) AS seq_num,
        DATEADD('day', (ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) * 7, p.first_tuesday) AS period_start_date,
        DATEADD('day', (ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) * 7 + 6, p.first_tuesday) AS period_end_date
    FROM TABLE(GENERATOR(ROWCOUNT => 520))
    CROSS JOIN params AS p

),

periods AS (

    SELECT
        period_start_date,
        period_end_date,
        ROW_NUMBER() OVER (ORDER BY seq_num, period_start_date) AS period_num,
        MONTHNAME(period_start_date) AS month_name,
        TO_TIMESTAMP_NTZ(period_start_date) AS start_date_et,
        DATEADD('second', 86399, TO_TIMESTAMP_NTZ(period_end_date)) AS end_date_et
    FROM period_spine_raw
    WHERE period_start_date <= DATEADD('day', 14, CURRENT_DATE())

),

valid_accounts AS (

    SELECT acco_id
    FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts
    WHERE
        COALESCE(is_test_account, 0) = 0
        AND has_registered_fmx = TRUE

),

orders AS (

    SELECT
        o.account_id,
        CONVERT_TIMEZONE('UTC', 'America/New_York', o.order_created_at)::DATE AS order_date_et,
        o.filled_price_usd,
        o.filled_handle_usd
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_order_pnl AS o
    INNER JOIN valid_accounts AS a
        ON o.account_id = a.acco_id
    WHERE
        o.filled_handle_usd > 0
        AND o.order_created_at >= DATEADD('day', -1, '2026-03-01'::DATE)

),

period_activity AS (

    SELECT
        o.account_id,
        p.period_num,
        p.month_name,
        p.start_date_et,
        p.end_date_et,
        SUM(o.filled_handle_usd) AS total_volume_in_period,
        SUM(CASE WHEN o.filled_price_usd <= 0.29 THEN o.filled_handle_usd ELSE 0 END)
            AS vol_0_to_29_cents,
        SUM(CASE WHEN o.filled_price_usd BETWEEN 0.30 AND 0.70 THEN o.filled_handle_usd ELSE 0 END)
            AS vol_30_to_70_cents,
        SUM(CASE WHEN o.filled_price_usd BETWEEN 0.71 AND 0.99 THEN o.filled_handle_usd ELSE 0 END)
            AS vol_71_to_99_cents,
        SUM(
            CASE
                WHEN o.filled_price_usd <= 0.29 THEN o.filled_handle_usd * 0.015
                WHEN o.filled_price_usd BETWEEN 0.30 AND 0.70 THEN o.filled_handle_usd * 0.0075
                WHEN o.filled_price_usd BETWEEN 0.71 AND 0.99 THEN o.filled_handle_usd * 0.0025
                ELSE 0
            END
        ) AS total_tp_earned_in_period
    FROM orders AS o
    INNER JOIN periods AS p
        ON o.order_date_et BETWEEN p.period_start_date AND p.period_end_date
    GROUP BY 1, 2, 3, 4, 5

),

account_first_period AS (

    SELECT
        account_id,
        MIN(period_num) AS first_active_period_num
    FROM period_activity
    GROUP BY 1

),

account_periods AS (

    -- Every period from an account's first active period through today, including gaps
    SELECT
        afp.account_id,
        p.period_num,
        p.month_name,
        p.start_date_et,
        p.end_date_et
    FROM account_first_period AS afp
    INNER JOIN periods AS p
        ON
            afp.first_active_period_num <= p.period_num
            AND p.period_start_date <= CURRENT_DATE()

),

account_periods_with_activity AS (

    SELECT
        ap.account_id,
        ap.period_num,
        ap.month_name,
        ap.start_date_et,
        ap.end_date_et,
        COALESCE(pa.total_volume_in_period, 0) AS total_volume_in_period,
        COALESCE(pa.vol_0_to_29_cents, 0) AS vol_0_to_29_cents,
        COALESCE(pa.vol_30_to_70_cents, 0) AS vol_30_to_70_cents,
        COALESCE(pa.vol_71_to_99_cents, 0) AS vol_71_to_99_cents,
        COALESCE(pa.total_tp_earned_in_period, 0) AS total_tp_earned_in_period
    FROM account_periods AS ap
    LEFT JOIN period_activity AS pa
        ON
            ap.account_id = pa.account_id
            AND ap.period_num = pa.period_num

),

contact AS (

    SELECT
        COALESCE(NULLIF(TRIM(TO_VARCHAR(acco_id)), ''), 'No Account') AS acco_id,
        LISTAGG(DISTINCT fbg_name, ', ') WITHIN GROUP (ORDER BY fbg_name) AS fbg_rep_in_contact
    FROM FMX_ANALYTICS.CUSTOMER.fct_vip_contact_history
    GROUP BY 1

),

with_running_totals AS (

    SELECT
        ap.month_name,
        ap.period_num,
        ap.start_date_et,
        ap.end_date_et,
        ap.account_id,
        c.fbg_rep_in_contact,
        ap.total_volume_in_period,
        ap.vol_0_to_29_cents,
        ap.vol_30_to_70_cents,
        ap.vol_71_to_99_cents,
        ap.total_tp_earned_in_period,
        COALESCE(
            SUM(ap.total_tp_earned_in_period) OVER (
                PARTITION BY ap.account_id
                ORDER BY ap.period_num
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ),
            0
        ) AS total_tp_credited_to_date,
        SUM(ap.total_tp_earned_in_period) OVER (
            PARTITION BY ap.account_id
            ORDER BY ap.period_num
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS total_tp_earned_to_date
    FROM account_periods_with_activity AS ap
    LEFT JOIN contact AS c
        ON ap.account_id = c.acco_id

)

SELECT
    month_name AS month,
    period_num,
    start_date_et,
    end_date_et,
    account_id,
    fbg_rep_in_contact,
    ROUND(total_volume_in_period, 2) AS total_volume_in_period,
    ROUND(vol_0_to_29_cents, 2) AS vol_0_to_29_cents,
    ROUND(vol_30_to_70_cents, 2) AS vol_30_to_70_cents,
    ROUND(vol_71_to_99_cents, 2) AS vol_71_to_99_cents,
    ROUND(total_tp_earned_in_period, 2) AS total_tp_earned_in_period,
    ROUND(total_tp_credited_to_date, 2) AS total_tp_credited_to_date,
    ROUND(total_tp_earned_in_period, 2) AS period_tier_points_to_credit,
    ROUND(total_tp_earned_to_date, 2) AS total_tp_earned_to_date,
    CASE
        WHEN total_tp_earned_to_date <= 99 THEN 'ONEmember'
        WHEN total_tp_earned_to_date BETWEEN 100 AND 2499 THEN 'ONEmember Pro'
        WHEN total_tp_earned_to_date BETWEEN 2500 AND 9999 THEN 'ONEgold'
        WHEN total_tp_earned_to_date BETWEEN 10000 AND 19999 THEN 'ONEplatinum'
        WHEN total_tp_earned_to_date >= 20000 THEN 'ONEblack'
    END AS fone_tier_earned_to_date
FROM with_running_totals
ORDER BY account_id, period_num
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_tier_points", "profile_name": "user", "target_name": "default"} */
