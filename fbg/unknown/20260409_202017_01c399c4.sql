-- Query ID: 01c399c4-0212-6e7d-24dd-07031926f887
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:20:17.044000+00:00
-- Elapsed: 2358ms
-- Environment: FBG

WITH staging_notes AS (
SELECT 
    account_id,
    action_level,
    action_date,
    lvl_1_notes, 
    lvl_2_notes, 
    lvl_3_notes,
    last_updated_at::TIMESTAMP_TZ as last_updated_at,
    action_date::TIMESTAMP_TZ as cooldown_anchor_date
FROM FBG_ANALYTICS.SIGMA_FBG.PATH_1_RG_NOTES
UNION ALL 
  select
    cm.acco_id::VARCHAR as account_id,
    'level 2' as action_level,
    TRY_TO_DATE(LEFT(a.createddate,10)) as action_date,
    null as lvl_1_notes,
    a.subject as lvl_2_notes,
    null as lvl_3_notes,
    TRY_TO_TIMESTAMP_TZ(
        a.lastmodifieddate,
        'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'
    ) AS last_updated_at,
    coalesce(
      TRY_TO_TIMESTAMP(LEFT(a.completeddatetime,10)),  
      TRY_TO_DATE(a.activitydate),-- if you want timestamp
      TRY_TO_DATE(LEFT(a.createddate, 10))                                        -- or system field
    )::TIMESTAMP as cooldown_anchor_date
FROM FBG_SOURCE.SALESFORCE.O_TASK AS a
LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART AS cm 
    ON a.whatid = cm.salesforce_id
where 1=1
    AND a.subject = 'VIP Responsible Gaming Conversation'
) ,
track_1_recent_notes AS (
  SELECT 
    account_id,
    action_level,
    action_date AS track_one_action_date,
    lvl_1_notes, 
    lvl_2_notes, 
    lvl_3_notes,
    cooldown_anchor_date,
    last_updated_at
  FROM staging_notes
  WHERE action_level IN ('level 1','level 2','level 3')
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY account_id, action_level
    ORDER BY last_updated_at DESC
  ) = 1
),
track_1_pivot AS (
  SELECT
    account_id,
--Lvl 1 Data
    MAX(CASE WHEN action_level = 'level 1' THEN track_one_action_date END) AS lvl1_action_date,
    MAX(CASE WHEN action_level = 'level 1' THEN lvl_1_notes END) AS lvl1_notes,
    MAX(CASE WHEN action_level = 'level 1' THEN last_updated_at END) AS lvl1_last_updated_at,
--Lvl 2 Data
    MAX(CASE WHEN action_level = 'level 2' THEN track_one_action_date END) AS lvl2_action_date,
    MAX(CASE WHEN action_level = 'level 2' THEN lvl_2_notes END) AS lvl2_notes,
--Lvl 3 Data
    MAX(CASE WHEN action_level = 'level 3' THEN track_one_action_date END) AS lvl3_action_date,
    MAX(CASE WHEN action_level = 'level 3' THEN lvl_3_notes END) AS lvl3_notes,
--Cooldowns
    dateadd('month', 6, max(case when action_level = 'level 1' then cooldown_anchor_date end)) as l1_cooldown_end,
    dateadd('month', 6, max(case when action_level = 'level 2' then cooldown_anchor_date end)) as l2_cooldown_end,
    dateadd('year', 1, max(case when action_level = 'level 3' then cooldown_anchor_date end)) as l3_cooldown_end
  FROM track_1_recent_notes
  GROUP BY 1
),
track_2_recent_notes AS (
  SELECT 
    account_id,
    -- One-K overrides: latest non-null values
    ROUND(MAX_BY(one_k_pts_threshold, CASE WHEN one_k_pts_threshold IS NOT NULL THEN last_updated_at END), 2) AS one_k_pts_threshold,
    MAX_BY(one_k_threshold_reasoning, CASE WHEN one_k_pts_threshold IS NOT NULL THEN last_updated_at END) AS one_k_threshold_reasoning,
    -- Monetary risk overrides: latest non-null values
    ROUND(MAX_BY(monetary_risk_days_threshold, CASE WHEN monetary_risk_days_threshold IS NOT NULL THEN last_updated_at END), 0) AS monetary_risk_days_threshold,
    MAX_BY(monetary_risk_change_reasoning, CASE WHEN monetary_risk_days_threshold IS NOT NULL THEN last_updated_at END) AS monetary_risk_change_reasoning,
    -- NSF overrides: latest non-null values
    ROUND(MAX_BY(insufficient_funds_count_change, CASE WHEN insufficient_funds_count_change IS NOT NULL THEN last_updated_at END), 0) AS nsf_daily_count_threshold,
    ROUND(MAX_BY(insufficient_alert_day_override, CASE WHEN insufficient_alert_day_override IS NOT NULL THEN last_updated_at END), 0) AS nsf_alert_day_threshold,
    MAX_BY(insufficient_change_reason, CASE WHEN insufficient_funds_count_change IS NOT NULL THEN last_updated_at END) AS nsf_reasoning,
    -- Metadata: from the most recent row overall
    MAX_BY(action_type, last_updated_at) AS action_type,
    MAX_BY(actioned_date, last_updated_at) AS actioned_date,
    MAX_BY(last_updated_by, last_updated_at) AS reviewer,
    MAX(last_updated_at) AS last_updated_at
  FROM FBG_ANALYTICS.SIGMA_FBG.PATH_2_RG_NOTES
  WHERE account_id IS NOT NULL
  GROUP BY account_id
),
-- CRM Level 1 triggers (rg_affordability_flag from sportsbook_crm_attributes)
crm_l1_triggers AS (
  SELECT 
    acco_id,
    MAX(trigger_date) AS crm_l1_trigger_date
  FROM fbg_governance.governance.affordability_l1_crm_triggers
  GROUP BY 1
)
SELECT 
  COALESCE(t1.account_id, t2.account_id, crm.acco_id) AS acco_id,
--Lvl 1 Data (use latest trigger based on last_updated_at vs trigger_date)
  CASE 
    WHEN COALESCE(t1.lvl1_last_updated_at, TIMESTAMP '1900-01-01') >= COALESCE(crm.crm_l1_trigger_date::TIMESTAMP, TIMESTAMP '1900-01-01')
    THEN t1.lvl1_action_date
    ELSE crm.crm_l1_trigger_date
  END AS lvl1_action_date,
  CASE 
    WHEN COALESCE(t1.lvl1_last_updated_at, TIMESTAMP '1900-01-01') >= COALESCE(crm.crm_l1_trigger_date::TIMESTAMP, TIMESTAMP '1900-01-01')
    THEN t1.lvl1_notes
    ELSE 'XtremePush data'
  END AS lvl1_notes,
  -- Cooldown is 6 months from the latest L1 trigger (based on last_updated_at comparison)
  CASE 
    WHEN COALESCE(t1.lvl1_last_updated_at, TIMESTAMP '1900-01-01') >= COALESCE(crm.crm_l1_trigger_date::TIMESTAMP, TIMESTAMP '1900-01-01')
    THEN t1.l1_cooldown_end
    ELSE DATEADD('month', 6, crm.crm_l1_trigger_date)
  END AS l1_cooldown_end,
--Lvl 2 Data
  t1.lvl2_action_date,
  t1.lvl2_notes,
  t1.l2_cooldown_end,
--Lvl 3 Data
  t1.lvl3_action_date,
  t1.lvl3_notes,
  t1.l3_cooldown_end,
-- Track 2 Data (Neccton path overrides)
  t2.one_k_pts_threshold,
  t2.one_k_threshold_reasoning,
  t2.monetary_risk_days_threshold,
  t2.monetary_risk_change_reasoning,
  t2.nsf_daily_count_threshold,
  t2.nsf_alert_day_threshold,
  t2.nsf_reasoning,
  t2.action_type,
  t2.actioned_date,
  t2.reviewer
FROM track_1_pivot t1
FULL OUTER JOIN track_2_recent_notes t2
  ON t1.account_id = t2.account_id
FULL OUTER JOIN crm_l1_triggers crm
  ON COALESCE(t1.account_id, t2.account_id) = crm.acco_id
