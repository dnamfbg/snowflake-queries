-- Query ID: 01c39a2d-0212-644a-24dd-0703193eed43
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T22:05:30.294000+00:00
-- Elapsed: 155ms
-- Environment: FBG

SELECT "Custom SQL Query"."EXPECTED_LEADS_GENERATED_THIS_MONTH" AS "EXPECTED_LEADS_GENERATED_THIS_MONTH",
  "Custom SQL Query"."EXPECTED_SUCCESSFUL_SM_THIS_MONTH" AS "EXPECTED_SUCCESSFUL_SM_THIS_MONTH",
  "Custom SQL Query"."LEADS_GENERATED_PACING" AS "LEADS_GENERATED_PACING",
  "Custom SQL Query"."LEADS_GENERATED_THIS_MONTH" AS "LEADS_GENERATED_THIS_MONTH",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."NEW_LEAD_ASSIGNED_L30D" AS "NEW_LEAD_ASSIGNED_L30D",
  "Custom SQL Query"."NEW_LEAD_SM_SUBMITTED_L30D" AS "NEW_LEAD_SM_SUBMITTED_L30D",
  "Custom SQL Query"."NEW_LEAD_SUCCESSFUL_SM_L30D" AS "NEW_LEAD_SUCCESSFUL_SM_L30D",
  "Custom SQL Query"."PCT_NEW_LEAD_SM_SUBMITTED_L30D" AS "PCT_NEW_LEAD_SM_SUBMITTED_L30D",
  "Custom SQL Query"."PCT_SM_SUBMITTED_SUCCESSFUL_L30D" AS "PCT_SM_SUBMITTED_SUCCESSFUL_L30D",
  "Custom SQL Query"."SUCCESSFUL_SM_PACING" AS "SUCCESSFUL_SM_PACING",
  "Custom SQL Query"."SUCCESSFUL_SM_THIS_MONTH" AS "SUCCESSFUL_SM_THIS_MONTH"
FROM (
  WITH base AS (
  SELECT DISTINCT 
  lead_owner
  FROM fbg_analytics.vip.leads_daily
  )
  
  , lead_generation AS (
  SELECT DISTINCT 
  lead_creator
  , lead_creation_date
  , lead_id
  , status_match_end_date
  , trial_status
  FROM fbg_analytics.vip.leads_daily
  WHERE DATE_TRUNC('MONTH', lead_creation_date) = DATE_TRUNC('MONTH', CURRENT_DATE)
  AND DATE_TRUNC('MONTH', as_of_date) = DATE_TRUNC('MONTH', CURRENT_DATE)
  )
  
  , lead_generation_final AS (
  SELECT DISTINCT 
  lead_creator
  , CEIL((30 / DATE_PART('day', LAST_DAY(CURRENT_DATE))) * DATE_PART('day', CURRENT_DATE)) AS expected_leads_generated_this_month
  , CEIL((10 / DATE_PART('day', LAST_DAY(CURRENT_DATE))) * DATE_PART('day', CURRENT_DATE)) AS expected_successful_sm_this_month
  , COUNT(DISTINCT lead_id) AS leads_generated_this_month
  , COUNT(DISTINCT CASE WHEN trial_status = 'Success' THEN lead_id END) AS successful_sm_this_month
  , leads_generated_this_month / expected_leads_generated_this_month AS leads_generated_pacing
  , successful_sm_this_month / expected_successful_sm_this_month AS successful_sm_pacing
  FROM lead_generation
  GROUP BY ALL
  )
  
  , effort AS (
  SELECT DISTINCT 
  lead_owner
  , lead_id
  , MIN(as_of_date) AS first_assigned_date
  FROM fbg_analytics.vip.leads_daily
  WHERE lead_owner IS NOT NULL
  GROUP BY ALL
  HAVING first_assigned_date >= DATEADD(DAY, -30, CURRENT_DATE)
  )
  
  , effort_next AS (
  SELECT DISTINCT 
  l.lead_owner
  , l.lead_id
  , e.first_assigned_date
  , CASE WHEN COUNT_IF(l.status_match_start_date IS NOT NULL) > 0 THEN TRUE ELSE FALSE END AS is_sm_submitted
  , CASE WHEN l.status_match_start_date >= e.first_assigned_date AND l.trial_status = 'Success' THEN TRUE ELSE FALSE END AS is_successful_sm
  FROM fbg_analytics.vip.leads_daily AS l 
  INNER JOIN effort AS e 
      ON l.lead_id = e.lead_id
      AND l.as_of_date >= e.first_assigned_date
  GROUP BY ALL
  )
  
  , effort_final AS (
  SELECT DISTINCT 
  lead_owner
  , COALESCE(COUNT(DISTINCT lead_id), 0) AS new_lead_assigned_l30d
  , COALESCE(COUNT(DISTINCT CASE WHEN is_sm_submitted = TRUE THEN lead_id END), 0) AS new_lead_sm_submitted_l30d
  , COALESCE(COUNT(DISTINCT CASE WHEN is_successful_sm = TRUE THEN lead_id END), 0) AS new_lead_successful_sm_l30d
  , COALESCE(new_lead_sm_submitted_l30d / NULLIF(new_lead_assigned_l30d, 0), 0) AS pct_new_lead_sm_submitted_l30d
  , COALESCE(new_lead_successful_sm_l30d / NULLIF(new_lead_sm_submitted_l30d, 0), 0) AS pct_sm_submitted_successful_l30d
  FROM effort_next
  GROUP BY ALL
  )
  
  SELECT DISTINCT 
  b.lead_owner AS name
  , CEIL((30 / DATE_PART('day', LAST_DAY(CURRENT_DATE))) * DATE_PART('day', CURRENT_DATE)) AS expected_leads_generated_this_month
  , CEIL((10 / DATE_PART('day', LAST_DAY(CURRENT_DATE))) * DATE_PART('day', CURRENT_DATE)) AS expected_successful_sm_this_month
  , COALESCE(g.leads_generated_this_month, 0) AS leads_generated_this_month
  , COALESCE(g.successful_sm_this_month, 0) AS successful_sm_this_month
  , COALESCE(g.leads_generated_pacing, 0) AS leads_generated_pacing
  , COALESCE(g.successful_sm_pacing, 0) AS successful_sm_pacing
  , COALESCE(e.new_lead_assigned_l30d, 0) AS new_lead_assigned_l30d
  , COALESCE(e.new_lead_sm_submitted_l30d, 0) AS new_lead_sm_submitted_l30d
  , COALESCE(e.new_lead_successful_sm_l30d, 0) AS new_lead_successful_sm_l30d
  , COALESCE(e.pct_new_lead_sm_submitted_l30d, 0) AS pct_new_lead_sm_submitted_l30d
  , COALESCE(e.pct_sm_submitted_successful_l30d, 0) AS pct_sm_submitted_successful_l30d
  FROM base AS b 
  LEFT JOIN lead_generation_final AS g 
      ON b.lead_owner = g.lead_creator
  LEFT JOIN effort_final AS e 
      ON b.lead_owner = e.lead_owner
) "Custom SQL Query"
