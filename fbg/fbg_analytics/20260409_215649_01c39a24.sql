-- Query ID: 01c39a24-0212-644a-24dd-0703193cdb1b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:56:49.405000+00:00
-- Elapsed: 60499ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BONUS_AWARDED_DATE" AS "BONUS_AWARDED_DATE",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_SEGMENT" AS "BONUS_SEGMENT",
  "Custom SQL Query"."BONUS_STATE" AS "BONUS_STATE",
  "Custom SQL Query"."CURRENT_YEAR_TIER_POINTS" AS "CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."F1_TIER" AS "F1_TIER",
  "Custom SQL Query"."F1_TP" AS "F1_TP",
  "Custom SQL Query"."FANCASH_AMOUNT" AS "FANCASH_AMOUNT",
  "Custom SQL Query"."LOYALTY_TIER" AS "LOYALTY_TIER",
  "Custom SQL Query"."MILESTONE" AS "MILESTONE",
  "Custom SQL Query"."MILESTONE_NUMBER" AS "MILESTONE_NUMBER",
  "Custom SQL Query"."SEGMENT_CREATED" AS "SEGMENT_CREATED",
  "Custom SQL Query"."SEGMENT_NAME" AS "SEGMENT_NAME",
  "Custom SQL Query"."SM_TRIAL_STATUS" AS "SM_TRIAL_STATUS"
FROM (
  WITH milestones_2026 AS (
      SELECT
          bonus_campaign_id,
          milestone_number,
          milestone,
          bonus_segment,
          amount AS fancash_amount
      FROM FBG_ANALYTICS.product_and_customer.f1_bonus_campaigns
      WHERE bonus_year = 2026
        AND bonus_type = 'Milestone'
  ),
  
  user_tiers AS (
      SELECT
          acco_id,
          current_year_tier_points,
          loyalty_tier
      FROM FBG_ANALYTICS.product_and_customer.f1_attributes
      WHERE loyalty_tier IN (
          'ONEmember pro',
          'ONEgold',
          'ONEplatinum',
          'ONEblack'
      )
  ),
  
  account_segments AS (
      SELECT
          accounts_id AS acco_id,
          customer_segments_id AS segment_id,
          CONVERT_TIMEZONE('UTC','America/New_York', created) AS segment_created
      FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS
  ),
  
  account_bonuses AS (
      SELECT
          acco_id,
          bonus_campaign_id,
          state AS bonus_state,
          CONVERT_TIMEZONE('UTC','America/New_York', modified) AS bonus_awarded_date
      FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES
  ),
  
  customer_segments AS (
      SELECT
          id AS segment_id,
          TRY_PARSE_JSON(data):CustomerSegment:name::STRING AS segment_name
      FROM fbg_source.osb_source.customer_segments
  )
  
  SELECT
      ut.acco_id,
      ut.loyalty_tier as f1_tier,
      ut.current_year_tier_points as f1_tp,
      CASE WHEN s.acco_id IS NOT NULL Then TRIAL_STATUS ELSE 'No Status Match' END AS SM_Trial_Status,
  
      m.milestone_number,
      m.milestone,
      cs.segment_name,
      m.fancash_amount,
  
      m.bonus_campaign_id,
      m.bonus_segment,
  
      ut.current_year_tier_points,
      ut.loyalty_tier,
  
      seg.segment_created,
      bon.bonus_awarded_date,
      bon.bonus_state,
  
  FROM user_tiers ut
  CROSS JOIN milestones_2026 m
  
  LEFT JOIN account_segments seg ON ut.acco_id = seg.acco_id AND m.bonus_segment = seg.segment_id
  LEFT JOIN account_bonuses bon ON ut.acco_id = bon.acco_id AND m.bonus_campaign_id = bon.bonus_campaign_id
  LEFT JOIN FBG_ANALYTICS.product_and_customer.status_match s on ut.acco_id = s.acco_id
  LEFT JOIN customer_segments cs ON m.bonus_segment = cs.segment_id
  ORDER BY
      ut.acco_id,
      m.milestone_number
) "Custom SQL Query"
