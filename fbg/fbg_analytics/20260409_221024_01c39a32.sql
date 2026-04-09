-- Query ID: 01c39a32-0212-6e7d-24dd-070319401f83
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:10:24.492000+00:00
-- Elapsed: 48157ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BONUS_WINNINGS" AS "BONUS_WINNINGS",
  "Custom SQL Query"."CAMPAIGN_NAME" AS "CAMPAIGN_NAME",
  "Custom SQL Query"."CODED_CAS_TIER" AS "CODED_CAS_TIER",
  "Custom SQL Query"."CURRENT_CASINO_SEGMENT_TIER" AS "CURRENT_CASINO_SEGMENT_TIER",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."INTERACTION_TYPE" AS "INTERACTION_TYPE",
  "Custom SQL Query"."MESSAGE_TYPE" AS "MESSAGE_TYPE",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."RECOMMENDED_CASINO_BONUS_AWARDED_AMOUNT" AS "RECOMMENDED_CASINO_BONUS_AWARDED_AMOUNT",
  "Custom SQL Query"."USER_ID" AS "USER_ID",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  WITH
  rtc_top_up_campaigns AS
  (
  
  SELECT
  
      to_timestamp(timestamp)::date as date,
      ca.user_id,
      ca.campaign_name,
      ca.message_type,
      interaction_type,
      
  FROM 
  fbg_source.xtremepush.campaigns ca
  WHERE (LOWER(campaign_name) ILIKE '%vip casino rtc top up%' OR lower(campaign_name) ILIKE '%vip rtc top up%')
      and category_name = 'Casino Marketing '
      and to_timestamp(timestamp)::date > '2025-03-01'
      and message_type IN ('journey')
      and interaction_type = 'sent'
      
  ),
  bonus_winnings_last30
  AS
  (
  
  SELECT
      acco_id,
      SUM(CASE WHEN cpl.transaction = 'bonus winnings' THEN cpl.amount ELSE 0 END) AS bonus_winnings
  
  FROM
  fbg_analytics.product_and_customer.casino_promotions_ledger cpl
  WHERE cpl.day between cpl.day - 29 and cpl.day
  group by all 
  
  ),
  
  ggr_last_30
  AS
  (
  
  SELECT
      c.acco_id,
      sum(c.ggr) as ggr,
      sum(c.ngr) as ngr
  
  FROM
  fbg_analytics_engineering.casino.casino_daily_settled_agg c
  WHERE
  c.settled_date_alk BETWEEN c.settled_date_alk - 29 and c.settled_date_alk AND c.is_test_account = 0 and c.total_void = 0
  group by all 
  
  )
  
  SELECT 
  
  rtc.*,
  cm.acco_id,
  cm.vip_host,
  CASE WHEN recommended_casino_bonus_reason = 'RTC Top Up' THEN RECOMMENDED_CASINO_BONUS_AWARDED_AMOUNT ELSE 0 END as RECOMMENDED_CASINO_BONUS_AWARDED_AMOUNT,
  cm.coded_cas_tier,
  cm.current_casino_segment_tier,
  bl.bonus_winnings,
  gl.ggr,
  gl.ngr
  
  FROM 
  rtc_top_up_campaigns rtc
  left join fbg_analytics_engineering.customers.customer_mart cm on (rtc.user_id = cm.amelco_id)
  left join bonus_winnings_last30 bl ON (cm.acco_id = bl.acco_id)
  left join ggr_last_30 gl on (cm.acco_id = gl.acco_id)
  left join FBG_ANALYTICS.CASINO.CRM_CASINO_BONUS_MODEL cbm on (cbm.acco_id = gl.acco_id)
  WHERE cm.is_test_account = FALSE
  GROUP BY ALL
) "Custom SQL Query"
