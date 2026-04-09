-- Query ID: 01c39a3a-0212-67a9-24dd-0703194255a3
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T22:18:41.580000+00:00
-- Elapsed: 8119ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AS_OF_DATE" AS "AS_OF_DATE",
  "Custom SQL Query"."ATTRIBUTION" AS "ATTRIBUTION",
  "Custom SQL Query"."CALLS_INBOUND" AS "CALLS_INBOUND",
  "Custom SQL Query"."CALLS_INBOUND_LEAD_OWNER" AS "CALLS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."CALLS_OUTBOUND" AS "CALLS_OUTBOUND",
  "Custom SQL Query"."CALLS_OUTBOUND_LEAD_OWNER" AS "CALLS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."CASINO_ACQ_SPEND" AS "CASINO_ACQ_SPEND",
  "Custom SQL Query"."CASINO_EACQ_SPEND" AS "CASINO_EACQ_SPEND",
  "Custom SQL Query"."CASINO_EMIG_SPEND" AS "CASINO_EMIG_SPEND",
  "Custom SQL Query"."CASINO_ERET_SPEND" AS "CASINO_ERET_SPEND",
  "Custom SQL Query"."CASINO_MIG_SPEND" AS "CASINO_MIG_SPEND",
  "Custom SQL Query"."CASINO_ONE_CREDIT" AS "CASINO_ONE_CREDIT",
  "Custom SQL Query"."CASINO_RET_SPEND" AS "CASINO_RET_SPEND",
  "Custom SQL Query"."CURRENT_VIP" AS "CURRENT_VIP",
  "Custom SQL Query"."CUSTOMER_STATUS" AS "CUSTOMER_STATUS",
  "Custom SQL Query"."CVP" AS "CVP",
  "Custom SQL Query"."DEPOSITS" AS "DEPOSITS",
  "Custom SQL Query"."ECVP" AS "ECVP",
  "Custom SQL Query"."EMAILS_INBOUND" AS "EMAILS_INBOUND",
  "Custom SQL Query"."EMAILS_INBOUND_LEAD_OWNER" AS "EMAILS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."EMAILS_OUTBOUND" AS "EMAILS_OUTBOUND",
  "Custom SQL Query"."EMAILS_OUTBOUND_LEAD_OWNER" AS "EMAILS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."FORMER_VIP" AS "FORMER_VIP",
  "Custom SQL Query"."LEAD_CREATION_DATE" AS "LEAD_CREATION_DATE",
  "Custom SQL Query"."LEAD_CREATOR" AS "LEAD_CREATOR",
  "Custom SQL Query"."LEAD_ID" AS "LEAD_ID",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LEAD_SOURCE" AS "LEAD_SOURCE",
  "Custom SQL Query"."LEAD_SUBSOURCE" AS "LEAD_SUBSOURCE",
  "Custom SQL Query"."LOYALTY_TIER" AS "LOYALTY_TIER",
  "Custom SQL Query"."MONTH" AS "MONTH",
  "Custom SQL Query"."NUM_SF_CHANGES" AS "NUM_SF_CHANGES",
  "Custom SQL Query"."OC_CASH_HANDLE" AS "OC_CASH_HANDLE",
  "Custom SQL Query"."OC_ENGR" AS "OC_ENGR",
  "Custom SQL Query"."OC_GGR" AS "OC_GGR",
  "Custom SQL Query"."OC_NGR" AS "OC_NGR",
  "Custom SQL Query"."OC_VIP" AS "OC_VIP",
  "Custom SQL Query"."OSB_CASH_HANDLE" AS "OSB_CASH_HANDLE",
  "Custom SQL Query"."OSB_ENGR" AS "OSB_ENGR",
  "Custom SQL Query"."OSB_GGR" AS "OSB_GGR",
  "Custom SQL Query"."OSB_NGR" AS "OSB_NGR",
  "Custom SQL Query"."OSB_VIP" AS "OSB_VIP",
  "Custom SQL Query"."PRE_LEAD_ACCOUNT_STATUS" AS "PRE_LEAD_ACCOUNT_STATUS",
  "Custom SQL Query"."REGISTRATION_DATE" AS "REGISTRATION_DATE",
  "Custom SQL Query"."SF_FIELDS_CHANGED" AS "SF_FIELDS_CHANGED",
  "Custom SQL Query"."SPORTSBOOK_ACQ_SPEND" AS "SPORTSBOOK_ACQ_SPEND",
  "Custom SQL Query"."SPORTSBOOK_EACQ_SPEND" AS "SPORTSBOOK_EACQ_SPEND",
  "Custom SQL Query"."SPORTSBOOK_EMIG_SPEND" AS "SPORTSBOOK_EMIG_SPEND",
  "Custom SQL Query"."SPORTSBOOK_ERET_SPEND" AS "SPORTSBOOK_ERET_SPEND",
  "Custom SQL Query"."SPORTSBOOK_MIG_SPEND" AS "SPORTSBOOK_MIG_SPEND",
  "Custom SQL Query"."SPORTSBOOK_ONE_CREDIT" AS "SPORTSBOOK_ONE_CREDIT",
  "Custom SQL Query"."SPORTSBOOK_RET_SPEND" AS "SPORTSBOOK_RET_SPEND",
  "Custom SQL Query"."STAKE_FACTOR" AS "STAKE_FACTOR",
  "Custom SQL Query"."STATUS_MATCH_END_DATE" AS "STATUS_MATCH_END_DATE",
  "Custom SQL Query"."STATUS_MATCH_OPERATOR" AS "STATUS_MATCH_OPERATOR",
  "Custom SQL Query"."STATUS_MATCH_OPERATOR_TIER" AS "STATUS_MATCH_OPERATOR_TIER",
  "Custom SQL Query"."STATUS_MATCH_START_DATE" AS "STATUS_MATCH_START_DATE",
  "Custom SQL Query"."STATUS_MATCH_SUBMITTED_DATE" AS "STATUS_MATCH_SUBMITTED_DATE",
  "Custom SQL Query"."STATUS_MATCH_TIER_NAME" AS "STATUS_MATCH_TIER_NAME",
  "Custom SQL Query"."STATUS_MATCH_TIER_POINTS" AS "STATUS_MATCH_TIER_POINTS",
  "Custom SQL Query"."TEXTS_INBOUND" AS "TEXTS_INBOUND",
  "Custom SQL Query"."TEXTS_INBOUND_LEAD_OWNER" AS "TEXTS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."TEXTS_OUTBOUND" AS "TEXTS_OUTBOUND",
  "Custom SQL Query"."TEXTS_OUTBOUND_LEAD_OWNER" AS "TEXTS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."TOTAL_COMMS_INBOUND" AS "TOTAL_COMMS_INBOUND",
  "Custom SQL Query"."TOTAL_COMMS_INBOUND_LEAD_OWNER" AS "TOTAL_COMMS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."TOTAL_COMMS_OUTBOUND" AS "TOTAL_COMMS_OUTBOUND",
  "Custom SQL Query"."TOTAL_COMMS_OUTBOUND_LEAD_OWNER" AS "TOTAL_COMMS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."TOTAL_VIP_DOWNGRADE_DATE" AS "TOTAL_VIP_DOWNGRADE_DATE",
  "Custom SQL Query"."TOTAL_VIP_UPGRADE_DATE" AS "TOTAL_VIP_UPGRADE_DATE",
  "Custom SQL Query"."TRIAL_COMPLETED_DATE" AS "TRIAL_COMPLETED_DATE",
  "Custom SQL Query"."TRIAL_STATUS" AS "TRIAL_STATUS",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."WAC" AS "WAC",
  "Custom SQL Query"."WEEK" AS "WEEK",
  "Custom SQL Query"."WITHDRAWALS" AS "WITHDRAWALS"
FROM (
  WITH base AS (
  SELECT DISTINCT *
  FROM FBG_ANALYTICS.VIP.LEADS_DAILY
  WHERE lead_id IN (
      SELECT DISTINCT
      lead_id
      FROM FBG_ANALYTICS.VIP.LEADS_DAILY
      WHERE lead_owner IN ('Taylor OBrien', 'Kyle McQuillan', 'Taylor Gwiazdon', 'Darren OBrien','Chris Bukowski','Michael Del Zotto','Will Rolapp','Jamie Fitzsimmons','Matthew Fleisher','Michael Hermalyn','Robert Ferrara','Pete Donahue','Gregg Hiller','Dan Barzottini','Tim Riley','Dana White','Michael Bernstein')
  )
  )
  
  , contact_metrics_lead_owner AS (
  SELECT DISTINCT 
  lc.lead_id
  , lc.fbg_name
  , CONVERT_TIMEZONE('UTC', 'America/New_York', lc.message_date)::DATE AS date
  , SUM(inbound) AS total_comms_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Text' THEN inbound ELSE 0 END) AS texts_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Email' THEN inbound ELSE 0 END) AS emails_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Call' THEN inbound ELSE 0 END) AS calls_inbound_lead_owner
  , SUM(outbound) AS total_comms_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Text' THEN outbound ELSE 0 END) AS texts_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Email' THEN outbound ELSE 0 END) AS emails_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Call' THEN outbound ELSE 0 END) AS calls_outbound_lead_owner
  FROM fbg_analytics.vip.lead_contact_history AS lc
  GROUP BY 
  ALL
  )
  
  SELECT DISTINCT 
  b.*
  , lm.lead_source
  , lm.lead_subsource
  , lc.total_comms_inbound_lead_owner
  , lc.texts_inbound_lead_owner
  , lc.emails_inbound_lead_owner
  , lc.calls_inbound_lead_owner
  , lc.total_comms_outbound_lead_owner
  , lc.texts_outbound_lead_owner
  , lc.emails_outbound_lead_owner
  , lc.calls_outbound_lead_owner
  , sm.status_match_tier_points
  , sm.trial_completed_date
  FROM base AS b 
  LEFT JOIN fbg_analytics.vip.lead_machine AS lm 
      ON b.lead_id = lm.lead_id
  LEFT JOIN contact_metrics_lead_owner AS lc 
      ON b.lead_id = lc.lead_id 
      AND b.lead_owner = lc.fbg_name 
      AND b.as_of_date = lc.date
  LEFT JOIN fbg_analytics.product_and_customer.status_match AS sm 
      ON b.acco_id = sm.acco_id
) "Custom SQL Query"
