-- Query ID: 01c39a3d-0212-6dbe-24dd-07031942b92f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:21:54.160000+00:00
-- Elapsed: 2148ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_crm_campaign_performance
    
    
    
    as (WITH campaign_engagement AS (
    SELECT *
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_crm_campaign_engagement
    WHERE
        COALESCE(is_test, 0) = 0  -- Exclude test accounts
        
)

SELECT
    -- Campaign dimensions
    campaign_id,
    campaign_name,
    campaign_type,
    category_name,
    bonus_id,
    labels,
    message_variant,
    message_variant_name,
    message_type,
    push_title,
    acco_id,

    -- User dimensions
    reg_state,
    control_group_assigned_at_alk,

    -- Email engagement metrics
    email_sent_at_alk,
    email_sent_flag,
    email_opened_at_alk,
    email_clicked_at_alk,
    email_opened_flag,
    email_clicked_flag,
    hours_to_open,
    hours_to_click,

    -- Push engagement metrics
    push_sent_at_alk,
    push_sent_flag,
    push_clicked_at_alk,
    push_clicked_flag,
    hours_to_push_click,

    -- Customer lifecycle context (pre-campaign state)
    reg_date_alk,
    first_login_alk,
    kyc_verified_alk,
    first_fmx_deposit_date_alk,
    first_fmx_order_date_alk,
    customer_segment_at_send,

    -- Post-email activity: App sessions (1-day post-open, 7-day post-click)
    first_app_session_post_email_open_alk,
    first_app_session_post_email_click_alk,
    sessions_1d_post_email_open,
    sessions_7d_post_email_click,
    app_opened_1d_email_flag,
    app_opened_7d_email_flag,

    -- Post-email activity: KYC (7-day post-click)
    first_kyc_attempt_post_email_click_alk,
    first_kyc_verified_post_email_click_alk,
    kyc_started_7d_email_flag,
    kyc_verified_7d_email_flag,

    -- Post-email activity: Deposits (7-day post-click)
    first_deposit_post_email_click_alk,
    total_deposit_amount_7d_email,
    deposited_7d_email_flag,

    -- Post-email activity: Trades (7-day post-click)
    first_trade_post_email_click_alk,
    total_orders_7d_email,
    total_order_amount_7d_email,
    traded_7d_email_flag,

    -- Post-push activity: App sessions (24-hour post-click)
    first_app_session_post_push_click_alk,
    sessions_24h_post_push_click,
    app_opened_24h_push_flag,

    -- Post-push activity: KYC (24-hour post-click)
    first_kyc_attempt_post_push_click_alk,
    first_kyc_verified_post_push_click_alk,
    kyc_started_24h_push_flag,
    kyc_verified_24h_push_flag,

    -- Post-push activity: Deposits (24-hour post-click)
    first_deposit_post_push_click_alk,
    total_deposit_amount_24h_push,
    deposited_24h_push_flag,

    -- Post-push activity: Trades (24-hour post-click)
    first_trade_post_push_click_alk,
    total_orders_24h_push,
    total_order_amount_24h_push,
    traded_24h_push_flag,

    -- Campaign send date
    campaign_send_date,

    -- Conversion timing (hours from email/push click to activity)
    hours_email_click_to_app_open,
    hours_email_click_to_kyc,
    hours_email_click_to_deposit,
    hours_email_click_to_trade,
    hours_push_click_to_app_open,
    hours_push_click_to_kyc,
    hours_push_click_to_deposit,
    hours_push_click_to_trade

FROM campaign_engagement
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_crm_campaign_performance", "profile_name": "user", "target_name": "default"} */
