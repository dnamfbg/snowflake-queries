-- Query ID: 01c39a51-0212-6dbe-24dd-07031946ccdf
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Last Executed: 2026-04-09T22:41:07.482000+00:00
-- Elapsed: 40191ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."ACQUISITION_PROMOTION_CODE_ON_REGISTRATION" AS "ACQUISITION_PROMOTION_CODE_ON_REGISTRATION",
  "Custom SQL Query"."AGENT_ID" AS "AGENT_ID",
  "Custom SQL Query"."AGENT_NAME" AS "AGENT_NAME",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_NAME" AS "BONUS_NAME",
  "Custom SQL Query"."CASE_CLOSED_EST" AS "CASE_CLOSED_EST",
  "Custom SQL Query"."CASE_CREATED_EST" AS "CASE_CREATED_EST",
  "Custom SQL Query"."CASE_ID" AS "CASE_ID",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_STATUS" AS "CASE_STATUS",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."CSAT_SCORE" AS "CSAT_SCORE",
  "Custom SQL Query"."CURRENT_CASINO_SEGMENT" AS "CURRENT_CASINO_SEGMENT",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query"."INTENDED_AWARD_AMOUNT" AS "INTENDED_AWARD_AMOUNT",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG",
  "Custom SQL Query"."PRODUCT_PREFERENCE" AS "PRODUCT_PREFERENCE",
  "Custom SQL Query"."QUALIFYING_WAGER_AMOUNT" AS "QUALIFYING_WAGER_AMOUNT",
  "Custom SQL Query"."QUALIFYING_WAGER_ID" AS "QUALIFYING_WAGER_ID",
  "Custom SQL Query"."QUALIFYING_WAGER_TIMESTAMP_EST" AS "QUALIFYING_WAGER_TIMESTAMP_EST",
  "Custom SQL Query"."REGISTRATION_DATE_EST" AS "REGISTRATION_DATE_EST",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE",
  "Custom SQL Query"."USER_LIFECYCLE_STAGE" AS "USER_LIFECYCLE_STAGE",
  "Custom SQL Query"."VIP_FLAG" AS "VIP_FLAG",
  "Custom SQL Query"."VOUCHER_CODE" AS "VOUCHER_CODE"
FROM (
  with gdg_cases as (
      SELECT
          cc.case_created_est
          , cc.case_closed_est
          , cc.case_number
          , cc.case_id
          , cc.account_id 
          , agent_id
          , agent_name
          , cc.case_type
          , cc.case_subtype
          , cc.case_status
          , oc.description
          , cc.lifecycle as user_lifecycle_stage
          , cc.product_flag
          , cc.product_preference
          , cc.is_any_vip as vip_flag
          , cc.csat_score
      from FBG_ANALYTICS.OPERATIONS.cs_cases as cc   
          inner join FBG_SOURCE.SALESFORCE.O_CASE AS oc 
              on oc.id = cc.case_id
      where 1=1 
          and (lower(oc.description) like '%gameday%'
               or lower(oc.description) like '%game day%'
               or case_subtype = 'Gameday Guarantee')
          and case_created_est >= '2025-08-01'
  )
  
  
  
  , gdg_contacts as ( 
      select
           cm.acco_id as account_id
          , cm.acquisition_bonus_name
          , cm.acquisition_promotion_code_on_registration
          , cm.product_preference
          , cm.current_casino_segment
          , cm.current_value_band
          , cm.registration_date_est
          , cm.registration_state
          , cm.current_state
          
          , gc.case_created_est
          , gc.case_closed_est
          , gc.case_number
          , gc.case_id
          , gc.agent_id
          , gc.agent_name
          , gc.case_type
          , gc.case_subtype
          , gc.case_status
          , gc.description
          , gc.user_lifecycle_stage
          , gc.product_flag
          , gc.vip_flag
          , gc.csat_score
      from FBG_ANALYTICS_ENGINEERING.customers.customer_mart as cm  
          left join gdg_cases gc 
              on gc.account_id = cm.acco_id
      where 1=1 
          and cm.is_test_account = FALSE
      )
      select
          g.*
          , acs.bet_id as qualifying_wager_id
          , case when acs.trans = 'STAKE' then convert_timezone('UTC', 'America/New_York',acs.trans_date) end as qualifying_wager_timestamp_est
          , acs.bonus_campaign_id
          , try_parse_json(acs.additional_info):bonusCode::string as voucher_code
          , try_parse_json(data):Bonus:name::string as bonus_name
          , case when acs.trans = 'STAKE' then abs(acs.amount) end as qualifying_wager_amount
          , case when acs2.trans = 'BONUS_EXECUTED' then acs2.amount end as intended_award_amount
      from gdg_contacts AS g
      left join FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS AS acs 
          on g.account_id = acs.acco_id
          and try_parse_json(acs.additional_info):bonusCode::string like 'GDG%'
          and acs.trans = 'STAKE'
          and date(convert_timezone('UTC', 'America/New_York',acs.trans_date)) between date(dateadd('day',-10,current_date())) and current_date()
      left join FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS AS acs2
          on acs.bet_id = acs2.bet_id
          and acs2.trans = 'BONUS_EXECUTED'
      left join FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS AS bc 
          on bc.id = acs.bonus_campaign_id
) "Custom SQL Query"
