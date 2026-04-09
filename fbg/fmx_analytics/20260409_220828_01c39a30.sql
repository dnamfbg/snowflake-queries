-- Query ID: 01c39a30-0212-6e7d-24dd-0703193f9c3b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:28.039000+00:00
-- Elapsed: 1024ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.CUSTOMER.int_xtremepush_campaigns_unified
  
  
  
  
  as (
    

WITH campaigns_archive AS (
    -- Project 13: Archive campaigns table (FMX campaigns only)
    -- user_id must be mapped to acco_id via the profiles table
    SELECT
        interaction_id,
        campaign_id,
        campaign_name,
        campaign_type,
        category_id,
        category_name,
        message_variant,
        message_variant_name,
        language_variant,
        campaign_schedule_type,
        workflow_action_id,
        workflow_action_name,
        labels,
        bonus_id,
        message_type,
        message_type_raw,
        push_title,
        profile_id,
        device_id,
        email,
        mobile_number,
        interaction_type,
        interaction_value,
        trigger_id,
        external_message_id,
        interaction_time_utc,
        interaction_time_alk,
        interaction_time_est,
        interaction_date_alk,
        dw_file_name,
        dw_last_updated,
        user_id,
        source_project
    FROM FMX_ANALYTICS.STAGING.stg_fmx_campaigns_archive
    WHERE
        -- Filter for FMX campaigns (both marketing and transactional)
        campaign_name ILIKE '%FMX%'
        -- Email campaigns only from project 13
        AND message_type = 'EMAIL'
        -- Interaction types for engagement tracking (including control group)
        AND interaction_type IN ('sent', 'delivery', 'open', 'click', 'control')
),

campaigns_current AS (
    -- Project 14: Current FMX_CAMPAIGNS table (email, push, and journey campaigns)
    -- user_id IS acco_id directly for both email and push (no profiles table join needed)
    SELECT
        interaction_id,
        campaign_id,
        campaign_name,
        campaign_type,
        category_id,
        category_name,
        message_variant,
        message_variant_name,
        language_variant,
        campaign_schedule_type,
        workflow_action_id,
        workflow_action_name,
        labels,
        bonus_id,
        message_type,
        message_type_raw,
        push_title,
        profile_id,
        device_id,
        email,
        mobile_number,
        interaction_type,
        interaction_value,
        trigger_id,
        external_message_id,
        interaction_time_utc,
        interaction_time_alk,
        interaction_time_est,
        interaction_date_alk,
        dw_file_name,
        dw_last_updated,
        user_id,
        'project_14_current' AS source_project
    FROM FMX_ANALYTICS.STAGING.stg_fmx_campaigns
    WHERE
        -- Email and Push campaigns from project 14
        -- Push message types are: PUSH (normalized)
        (
            message_type = 'EMAIL'
            OR message_type = 'PUSH'
        )
        -- Email: track all interaction types except delivery (not tracked)
        -- Push: only track sent, open, and click (per requirements)
        AND (
            (message_type = 'EMAIL' AND interaction_type IN ('sent', 'open', 'click', 'control'))
            OR (message_type = 'PUSH' AND interaction_type IN ('sent', 'open', 'click'))
        )
),

all_campaigns AS (
    -- Union both sources
    SELECT * FROM campaigns_archive
    UNION ALL
    SELECT * FROM campaigns_current
),

email_profiles AS (
    -- Email campaigns (project 13 only): user_id must be mapped via profiles table
    -- Project 14 emails use user_id = acco_id directly
    SELECT
        user_id,
        acco_id
    FROM FMX_ANALYTICS.STAGING.stg_xtremepush_profiles
)

SELECT
    -- Primary keys
    c.interaction_id,
    c.campaign_id,

    -- Campaign attributes
    c.campaign_name,
    c.campaign_type,
    c.category_id,
    c.category_name,
    c.message_variant,
    c.message_variant_name,
    c.language_variant,
    c.campaign_schedule_type,
    c.workflow_action_id,
    c.workflow_action_name,
    c.labels,
    c.bonus_id,

    -- Message type and content
    c.message_type,
    c.message_type_raw,
    c.push_title,

    -- User identifiers
    c.profile_id,
    c.device_id,
    c.email,
    c.mobile_number,

    -- Interaction details
    c.interaction_type,
    c.interaction_value,
    c.trigger_id,
    c.external_message_id,

    -- Timestamps
    c.interaction_time_utc,
    c.interaction_time_alk,
    c.interaction_time_est,
    c.interaction_date_alk,

    -- Metadata
    c.dw_file_name,
    c.dw_last_updated,
    c.source_project,

    -- Map to internal acco_id
    -- Project 13 emails: join to profiles table to get acco_id
    -- Project 14 emails and all push: user_id IS acco_id directly (99% coverage)
    c.user_id::VARCHAR AS xtremepush_user_id,
    CASE
        WHEN c.message_type = 'EMAIL' AND c.source_project = 'project_13_archive' THEN ep.acco_id
        WHEN c.message_type = 'EMAIL' AND c.source_project = 'project_14_current' THEN c.user_id::VARCHAR
        WHEN c.message_type = 'PUSH' THEN c.user_id::VARCHAR
    END AS acco_id

FROM all_campaigns AS c
-- Project 13 emails only: join to profiles table to get acco_id
LEFT JOIN email_profiles AS ep
    ON
        c.user_id = ep.user_id
        AND c.message_type = 'EMAIL'
        AND c.source_project = 'project_13_archive'
WHERE
    -- Project 13 emails: must have acco_id from profiles join
    -- Project 14 emails and push: must have user_id (which IS the acco_id)
    (
        (c.message_type = 'EMAIL' AND c.source_project = 'project_13_archive' AND ep.acco_id IS NOT NULL)
        OR (c.message_type = 'EMAIL' AND c.source_project = 'project_14_current' AND c.user_id IS NOT NULL)
        OR (c.message_type = 'PUSH' AND c.user_id IS NOT NULL)
    )
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.int_xtremepush_campaigns_unified", "profile_name": "user", "target_name": "default"} */
