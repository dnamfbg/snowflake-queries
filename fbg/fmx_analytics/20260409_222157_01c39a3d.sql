-- Query ID: 01c39a3d-0212-67a8-24dd-07031942d7b3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:21:57.086000+00:00
-- Elapsed: 3511ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.fct_fmx_crm_campaign_daily_summary
    
    
    
    as (-- Daily campaign-level summary for dashboard
-- Same metrics as fct_fmx_crm_campaign_summary but at daily grain
-- One row per campaign variant per send date
-- Handles both EMAIL and PUSH campaigns with appropriate attribution windows (7-day email, 24-hour push)

WITH campaign_metrics AS (
    SELECT
        -- Campaign dimensions
        campaign_id,
        campaign_name,
        campaign_type,
        category_name,
        bonus_id,
        message_variant,
        message_variant_name,
        message_type,

        -- Daily grain
        campaign_send_date,

        -- Aggregated labels
        LISTAGG(DISTINCT labels, ', ')
        WITHIN GROUP (ORDER BY labels) AS labels,

        -- Recipient counts
        COUNT(DISTINCT acco_id) AS total_recipients,

        -- Control group
        COUNT(
            DISTINCT
            CASE
                WHEN control_group_assigned_at_alk IS NOT NULL
                    THEN acco_id
            END
        ) AS total_control_group,

        -- Email engagement counts
        SUM(email_sent_flag) AS total_email_sent,
        SUM(email_opened_flag) AS total_email_opened,
        SUM(email_clicked_flag) AS total_email_clicked,

        -- Push engagement counts
        SUM(push_sent_flag) AS total_push_sent,
        SUM(push_clicked_flag) AS total_push_clicked,

        -- Email product engagement counts (7-day post-click)
        SUM(app_opened_7d_email_flag) AS total_email_app_opens,
        SUM(kyc_started_7d_email_flag) AS total_email_kyc_started,
        SUM(kyc_verified_7d_email_flag) AS total_email_kyc_verified,
        SUM(deposited_7d_email_flag) AS total_email_deposits,
        SUM(traded_7d_email_flag) AS total_email_traders,

        -- Email order and deposit amounts (7-day post-click)
        SUM(total_orders_7d_email) AS total_email_orders,
        SUM(total_order_amount_7d_email) AS total_email_order_amount,
        SUM(total_deposit_amount_7d_email) AS total_email_deposit_amount,

        -- Push product engagement counts (24-hour post-click)
        SUM(app_opened_24h_push_flag) AS total_push_app_opens,
        SUM(kyc_started_24h_push_flag) AS total_push_kyc_started,
        SUM(kyc_verified_24h_push_flag) AS total_push_kyc_verified,
        SUM(deposited_24h_push_flag) AS total_push_deposits,
        SUM(traded_24h_push_flag) AS total_push_traders,

        -- Push order and deposit amounts (24-hour post-click)
        SUM(total_orders_24h_push) AS total_push_orders,
        SUM(total_order_amount_24h_push) AS total_push_order_amount,
        SUM(total_deposit_amount_24h_push) AS total_push_deposit_amount,

        -- Customer segment breakdown
        COUNT(
            DISTINCT
            CASE
                WHEN customer_segment_at_send = 'Active Trader'
                    THEN acco_id
            END
        ) AS active_traders,
        COUNT(
            DISTINCT
            CASE
                WHEN customer_segment_at_send = 'Funded Non-Trader'
                    THEN acco_id
            END
        ) AS funded_non_traders,
        COUNT(
            DISTINCT
            CASE
                WHEN customer_segment_at_send = 'KYC Verified Non-Funded'
                    THEN acco_id
            END
        ) AS kyc_verified_non_funded,
        COUNT(
            DISTINCT
            CASE
                WHEN customer_segment_at_send = 'Registered Non-KYC'
                    THEN acco_id
            END
        ) AS registered_non_kyc,
        COUNT(
            DISTINCT
            CASE
                WHEN customer_segment_at_send = 'New Registration'
                    THEN acco_id
            END
        ) AS new_registrations

    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_crm_campaign_performance
    WHERE
        campaign_send_date IS NOT NULL
        
    GROUP BY
        campaign_id,
        campaign_name,
        campaign_type,
        category_name,
        bonus_id,
        message_variant,
        message_variant_name,
        message_type,
        campaign_send_date
)

SELECT
    -- Campaign dimensions
    campaign_id,
    campaign_name,
    campaign_send_date,
    campaign_type,
    category_name,
    bonus_id,
    labels,
    message_variant,
    message_variant_name,
    message_type,
    total_recipients,
    total_control_group,

    -- Counts
    total_email_sent,
    total_email_opened,

    -- Email metrics
    total_email_clicked,
    total_email_app_opens,
    total_email_kyc_started,
    total_email_kyc_verified,
    total_email_deposits,
    total_email_traders,
    total_email_orders,
    total_email_order_amount,
    total_email_deposit_amount,
    total_push_sent,
    total_push_clicked,

    -- Push metrics
    total_push_app_opens,
    total_push_kyc_started,
    total_push_kyc_verified,
    total_push_deposits,
    total_push_traders,
    total_push_orders,
    total_push_order_amount,
    total_push_deposit_amount,
    active_traders,
    funded_non_traders,

    -- Segment breakdown
    kyc_verified_non_funded,
    registered_non_kyc,
    new_registrations,
    CASE
        WHEN campaign_name ILIKE '%TRIGGERED%' THEN 'Automation'
        ELSE 'Broadcast'
    END AS campaign_delivery_type,
    COALESCE (COUNT(*) OVER (
        PARTITION BY campaign_id, message_type, campaign_send_date
    ) > 1, FALSE) AS is_experiment,

    -- Email engagement rates (based on sent)
    CASE
        WHEN total_email_sent > 0
            THEN total_email_opened::FLOAT / total_email_sent
    END AS email_open_rate,

    CASE
        WHEN total_email_sent > 0
            THEN total_email_clicked::FLOAT / total_email_sent
    END AS email_click_rate,

    -- Email conversion rates (based on recipients)
    CASE
        WHEN total_recipients > 0
            THEN total_email_app_opens::FLOAT / total_recipients
    END AS email_app_open_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_email_kyc_started::FLOAT / total_recipients
    END AS email_kyc_started_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_email_kyc_verified::FLOAT / total_recipients
    END AS email_kyc_verified_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_email_deposits::FLOAT / total_recipients
    END AS email_deposit_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_email_traders::FLOAT / total_recipients
    END AS email_trade_rate,

    -- Push engagement rates (based on sent)
    CASE
        WHEN total_push_sent > 0
            THEN total_push_clicked::FLOAT / total_push_sent
    END AS push_click_rate,

    -- Push conversion rates (based on recipients)
    CASE
        WHEN total_recipients > 0
            THEN total_push_app_opens::FLOAT / total_recipients
    END AS push_app_open_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_push_kyc_started::FLOAT / total_recipients
    END AS push_kyc_started_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_push_kyc_verified::FLOAT / total_recipients
    END AS push_kyc_verified_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_push_deposits::FLOAT / total_recipients
    END AS push_deposit_rate,

    CASE
        WHEN total_recipients > 0
            THEN total_push_traders::FLOAT / total_recipients
    END AS push_trade_rate

FROM campaign_metrics
ORDER BY campaign_send_date, campaign_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_crm_campaign_daily_summary", "profile_name": "user", "target_name": "default"} */
