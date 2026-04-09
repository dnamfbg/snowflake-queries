-- Query ID: 01c39a36-0212-644a-24dd-070319413b0b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:14:32.020000+00:00
-- Elapsed: 129368ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_BONUS_STATE" AS "ACCOUNT_BONUS_STATE",
  "Custom SQL Query"."ACCOUNT_STATUS" AS "ACCOUNT_STATUS",
  "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_CAMPAIGN_NAME" AS "BONUS_CAMPAIGN_NAME",
  "Custom SQL Query"."BONUS_NAME" AS "BONUS_NAME",
  "Custom SQL Query"."BONUS_STAKES_AMOUNT" AS "BONUS_STAKES_AMOUNT",
  "Custom SQL Query"."BONUS_STATUS" AS "BONUS_STATUS",
  "Custom SQL Query"."CALLS_INBOUND" AS "CALLS_INBOUND",
  "Custom SQL Query"."CALLS_INBOUND_LEAD_OWNER" AS "CALLS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."CALLS_OUTBOUND" AS "CALLS_OUTBOUND",
  "Custom SQL Query"."CALLS_OUTBOUND_LEAD_OWNER" AS "CALLS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."CAMPAIGN_NAME" AS "CAMPAIGN_NAME",
  "Custom SQL Query"."CAMPAIGN_NAME_" AS "CAMPAIGN_NAME_",
  "Custom SQL Query"."CAMPAIGN_START_DATE" AS "CAMPAIGN_START_DATE",
  "Custom SQL Query"."CAN_CONTACT" AS "CAN_CONTACT",
  "Custom SQL Query"."CAN_CONTACT_DAILY" AS "CAN_CONTACT_DAILY",
  "Custom SQL Query"."CAN_CONTACT_REASON" AS "CAN_CONTACT_REASON",
  "Custom SQL Query"."CAN_CONTACT_REASON_DAILY" AS "CAN_CONTACT_REASON_DAILY",
  "Custom SQL Query"."CASH_HANDLE_90_DAYS_PRE_OFFER" AS "CASH_HANDLE_90_DAYS_PRE_OFFER",
  "Custom SQL Query"."CURRENT_BALANCE" AS "CURRENT_BALANCE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."CVP_POST_OFFER" AS "CVP_POST_OFFER",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."DATE_COHORT" AS "DATE_COHORT",
  "Custom SQL Query"."DAYS_SINCE_FIRST_DEPOSIT_POST_OFFER" AS "DAYS_SINCE_FIRST_DEPOSIT_POST_OFFER",
  "Custom SQL Query"."DAYS_SINCE_OFFER" AS "DAYS_SINCE_OFFER",
  "Custom SQL Query"."DAYS_UNTIL_FIRST_HOSTED" AS "DAYS_UNTIL_FIRST_HOSTED",
  "Custom SQL Query"."DEPOSITS_POST_OFFER" AS "DEPOSITS_POST_OFFER",
  "Custom SQL Query"."DEPOSIT_TIME_POST_OFFER" AS "DEPOSIT_TIME_POST_OFFER",
  "Custom SQL Query"."ECVP_POST_OFFER" AS "ECVP_POST_OFFER",
  "Custom SQL Query"."EMAILS_INBOUND" AS "EMAILS_INBOUND",
  "Custom SQL Query"."EMAILS_INBOUND_LEAD_OWNER" AS "EMAILS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."EMAILS_OUTBOUND" AS "EMAILS_OUTBOUND",
  "Custom SQL Query"."EMAILS_OUTBOUND_LEAD_OWNER" AS "EMAILS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."F1_POINTS_TIER" AS "F1_POINTS_TIER",
  "Custom SQL Query"."FANCASH_AMOUNT" AS "FANCASH_AMOUNT",
  CAST("Custom SQL Query"."FIRST_CASH_STAKE_TIME_POST_OFFER" AS DATE) AS "FIRST_CASH_STAKE_TIME_POST_OFFER",
  "Custom SQL Query"."FIRST_CASH_STAKE_TIME_POST_OFFER_ALK" AS "FIRST_CASH_STAKE_TIME_POST_OFFER_ALK",
  "Custom SQL Query"."FIRST_DEPOSIT_DATE_POST_OFFER" AS "FIRST_DEPOSIT_DATE_POST_OFFER",
  "Custom SQL Query"."FIRST_DEPOSIT_TIME_POST_OFFER" AS "FIRST_DEPOSIT_TIME_POST_OFFER",
  "Custom SQL Query"."FIRST_HOSTED_DATE_SINCE_CAMPAIGN" AS "FIRST_HOSTED_DATE_SINCE_CAMPAIGN",
  CAST("Custom SQL Query"."FIRST_INBOUND_CONTACT_TIME_POST_OFFER" AS DATE) AS "FIRST_INBOUND_CONTACT_TIME_POST_OFFER",
  "Custom SQL Query"."FIRST_OC_CASH_STAKE_TIME_POST_OFFER" AS "FIRST_OC_CASH_STAKE_TIME_POST_OFFER",
  "Custom SQL Query"."FIRST_OC_CASH_STAKE_TIME_POST_OFFER_ALK" AS "FIRST_OC_CASH_STAKE_TIME_POST_OFFER_ALK",
  "Custom SQL Query"."FIRST_OSB_CASH_STAKE_TIME_POST_OFFER" AS "FIRST_OSB_CASH_STAKE_TIME_POST_OFFER",
  "Custom SQL Query"."FIRST_OSB_CASH_STAKE_TIME_POST_OFFER_ALK" AS "FIRST_OSB_CASH_STAKE_TIME_POST_OFFER_ALK",
  "Custom SQL Query"."HAS_DEPOSIT" AS "HAS_DEPOSIT",
  "Custom SQL Query"."HAS_FANATICS_FEST_EMAIL" AS "HAS_FANATICS_FEST_EMAIL",
  "Custom SQL Query"."HAS_HERM_EMAIL" AS "HAS_HERM_EMAIL",
  "Custom SQL Query"."HAS_OUTBOUND_CONTACT_LEAD_OWNER" AS "HAS_OUTBOUND_CONTACT_LEAD_OWNER",
  "Custom SQL Query"."HAS_OUTBOUND_EMAIL" AS "HAS_OUTBOUND_EMAIL",
  "Custom SQL Query"."HAS_OUTBOUND_EMAIL_LEAD_OWNER" AS "HAS_OUTBOUND_EMAIL_LEAD_OWNER",
  "Custom SQL Query"."HAS_RESPONSE" AS "HAS_RESPONSE",
  "Custom SQL Query"."HAS_ROB_FOLLOW_UP_EMAIL" AS "HAS_ROB_FOLLOW_UP_EMAIL",
  "Custom SQL Query"."IS_ACTIVE" AS "IS_ACTIVE",
  "Custom SQL Query"."IS_LEAD_GEN" AS "IS_LEAD_GEN",
  "Custom SQL Query"."IS_NEW_SIGNUP" AS "IS_NEW_SIGNUP",
  "Custom SQL Query"."LAST_CASH_ACTIVE_DATE" AS "LAST_CASH_ACTIVE_DATE",
  "Custom SQL Query"."LAST_DEPOSIT_DATE" AS "LAST_DEPOSIT_DATE",
  "Custom SQL Query"."LAST_INBOUND_CONTACT_DATE" AS "LAST_INBOUND_CONTACT_DATE",
  CAST("Custom SQL Query"."LAST_LOGIN_TIME_EST" AS DATE) AS "LAST_LOGIN_TIME_EST",
  "Custom SQL Query"."LAST_MODIFIED_TIME" AS "LAST_MODIFIED_TIME",
  "Custom SQL Query"."LAST_OUTBOUND_CONTACT_DATE" AS "LAST_OUTBOUND_CONTACT_DATE",
  "Custom SQL Query"."LAST_OUTBOUND_CONTACT_DATE_LEAD_OWNER" AS "LAST_OUTBOUND_CONTACT_DATE_LEAD_OWNER",
  "Custom SQL Query"."LAST_OUTBOUND_EMAIL_DATE_LEAD_OWNER" AS "LAST_OUTBOUND_EMAIL_DATE_LEAD_OWNER",
  "Custom SQL Query"."LAST_WITHDRAWAL_DATE" AS "LAST_WITHDRAWAL_DATE",
  "Custom SQL Query"."LEAD_ID" AS "LEAD_ID",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LEAD_OWNER_DAILY" AS "LEAD_OWNER_DAILY",
  "Custom SQL Query"."LEAD_SOURCE" AS "LEAD_SOURCE",
  "Custom SQL Query"."LEAD_STATUS" AS "LEAD_STATUS",
  "Custom SQL Query"."LEAD_SUBSOURCE" AS "LEAD_SUBSOURCE",
  "Custom SQL Query"."LOYALTY_TIER_CAMPAIGN_START" AS "LOYALTY_TIER_CAMPAIGN_START",
  "Custom SQL Query"."MAXED_OUT" AS "MAXED_OUT",
  "Custom SQL Query"."MAX_QUAL_DEPOSIT_AMOUNT" AS "MAX_QUAL_DEPOSIT_AMOUNT",
  "Custom SQL Query"."MESSAGES_UNTIL_FIRST_TIME_CASH_STAKE" AS "MESSAGES_UNTIL_FIRST_TIME_CASH_STAKE",
  "Custom SQL Query"."MESSAGES_UNTIL_FIRST_TIME_DEPOSIT" AS "MESSAGES_UNTIL_FIRST_TIME_DEPOSIT",
  "Custom SQL Query"."MESSAGES_UNTIL_FIRST_TIME_INBOUND_CONTACT" AS "MESSAGES_UNTIL_FIRST_TIME_INBOUND_CONTACT",
  "Custom SQL Query"."NET_DEPOSITS_POST_OFFER" AS "NET_DEPOSITS_POST_OFFER",
  "Custom SQL Query"."NEXT_WITHDRAWAL_POST_OFFER" AS "NEXT_WITHDRAWAL_POST_OFFER",
  "Custom SQL Query"."OC_CASH_STAKE_POST_OFFER" AS "OC_CASH_STAKE_POST_OFFER",
  "Custom SQL Query"."OC_ENGR_POST_OFFER" AS "OC_ENGR_POST_OFFER (Custom SQL Query)",
  "Custom SQL Query"."OC_NGR_POST_OFFER" AS "OC_NGR_POST_OFFER (Custom SQL Query)",
  "Custom SQL Query"."OFFER_SELECTED" AS "OFFER_SELECTED",
  "Custom SQL Query"."OPT_IN_TIME" AS "OPT_IN_TIME",
  "Custom SQL Query"."OSB_CASH_STAKE_POST_OFFER" AS "OSB_CASH_STAKE_POST_OFFER",
  "Custom SQL Query"."OSB_ENGR_POST_OFFER" AS "OSB_ENGR_POST_OFFER (Custom SQL Query)",
  "Custom SQL Query"."OSB_NGR_POST_OFFER" AS "OSB_NGR_POST_OFFER (Custom SQL Query)",
  "Custom SQL Query"."OSB_OPEN_CASH_STAKE" AS "OSB_OPEN_CASH_STAKE",
  "Custom SQL Query"."OWNERID" AS "OWNERID",
  "Custom SQL Query"."PERC_MAX_DEPOSIT" AS "PERC_MAX_DEPOSIT",
  "Custom SQL Query"."PSEUDONYM" AS "PSEUDONYM",
  "Custom SQL Query"."QUAL_BONUS_PCT" AS "QUAL_BONUS_PCT",
  CAST("Custom SQL Query"."SIGNUP_DATE" AS DATE) AS "SIGNUP_DATE",
  "Custom SQL Query"."STAGE" AS "STAGE",
  "Custom SQL Query"."STAGE_0_START_DATE" AS "STAGE_0_START_DATE",
  "Custom SQL Query"."STAGE_1_MESSAGE_TYPE_TRIGGER" AS "STAGE_1_MESSAGE_TYPE_TRIGGER",
  "Custom SQL Query"."STAGE_1_START_DATE" AS "STAGE_1_START_DATE",
  "Custom SQL Query"."STAGE_2_MESSAGE_TYPE_TRIGGER" AS "STAGE_2_MESSAGE_TYPE_TRIGGER",
  "Custom SQL Query"."STAGE_2_START_DATE" AS "STAGE_2_START_DATE",
  "Custom SQL Query"."STAGE_3_MESSAGE_TYPE_TRIGGER" AS "STAGE_3_MESSAGE_TYPE_TRIGGER",
  "Custom SQL Query"."STAGE_3_START_DATE" AS "STAGE_3_START_DATE",
  "Custom SQL Query"."STAGE_4_MESSAGE_TYPE_TRIGGER" AS "STAGE_4_MESSAGE_TYPE_TRIGGER",
  "Custom SQL Query"."STAGE_4_START_DATE" AS "STAGE_4_START_DATE",
  "Custom SQL Query"."STAGE_TYPE" AS "STAGE_TYPE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATUS_MATCH_OPERATOR" AS "STATUS_MATCH_OPERATOR",
  "Custom SQL Query"."STATUS_MATCH_OPERATOR_TIER" AS "STATUS_MATCH_OPERATOR_TIER",
  "Custom SQL Query"."STATUS_MATCH_STATUS" AS "STATUS_MATCH_STATUS",
  CAST("Custom SQL Query"."STATUS_MATCH_SUBMITTED_TIME" AS DATE) AS "STATUS_MATCH_SUBMITTED_TIME",
  "Custom SQL Query"."STATUS_MATCH_TIER_NAME" AS "STATUS_MATCH_TIER_NAME",
  "Custom SQL Query"."STATUS_MATCH_TIER_POINTS" AS "STATUS_MATCH_TIER_POINTS",
  CAST("Custom SQL Query"."STATUS_MATCH_TRIAL_START" AS DATE) AS "STATUS_MATCH_TRIAL_START",
  "Custom SQL Query"."SUCCESSFUL_EMAIL_STAGE_1" AS "SUCCESSFUL_EMAIL_STAGE_1",
  "Custom SQL Query"."SUCCESSFUL_EMAIL_STAGE_2" AS "SUCCESSFUL_EMAIL_STAGE_2",
  "Custom SQL Query"."SUCCESSFUL_EMAIL_STAGE_3" AS "SUCCESSFUL_EMAIL_STAGE_3",
  "Custom SQL Query"."TEXTS_INBOUND" AS "TEXTS_INBOUND",
  "Custom SQL Query"."TEXTS_INBOUND_LEAD_OWNER" AS "TEXTS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."TEXTS_OUTBOUND" AS "TEXTS_OUTBOUND",
  "Custom SQL Query"."TEXTS_OUTBOUND_LEAD_OWNER" AS "TEXTS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."TIER_POINTS_SINCE_OFFER" AS "TIER_POINTS_SINCE_OFFER",
  "Custom SQL Query"."TIME_TO_WITHDRAWAL" AS "TIME_TO_WITHDRAWAL",
  "Custom SQL Query"."TOTAL_COMMS_INBOUND" AS "TOTAL_COMMS_INBOUND",
  "Custom SQL Query"."TOTAL_COMMS_INBOUND_LEAD_OWNER" AS "TOTAL_COMMS_INBOUND_LEAD_OWNER",
  "Custom SQL Query"."TOTAL_COMMS_OUTBOUND" AS "TOTAL_COMMS_OUTBOUND",
  "Custom SQL Query"."TOTAL_COMMS_OUTBOUND_LEAD_OWNER" AS "TOTAL_COMMS_OUTBOUND_LEAD_OWNER",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."VIP_HOST_DAILY" AS "VIP_HOST_DAILY",
  "Custom SQL Query"."WAC" AS "WAC",
  "Custom SQL Query"."WEEKS_SINCE_FIRST_DEPOSIT_POST_OFFER" AS "WEEKS_SINCE_FIRST_DEPOSIT_POST_OFFER",
  "Custom SQL Query"."WEEKS_SINCE_OFFER" AS "WEEKS_SINCE_OFFER",
  "Custom SQL Query"."WHY_NOT_NEXT_STAGE" AS "WHY_NOT_NEXT_STAGE",
  "Custom SQL Query"."WITHDRAWALS_POST_OFFER" AS "WITHDRAWALS_POST_OFFER",
  "Custom SQL Query"."WITHIN_7_DAYS_OF_FIRST_DEPOSIT" AS "WITHIN_7_DAYS_OF_FIRST_DEPOSIT",
  "Custom SQL Query"."WITHIN_7_DAYS_OF_OFFER" AS "WITHIN_7_DAYS_OF_OFFER"
FROM (
  WITH base AS (
  SELECT t.calendar_date AS date
  , p.*
  FROM fbg_analytics.vip.project_250_campaigns AS p 
  INNER JOIN fbg_analytics.product_and_customer.t_calendar AS t 
      ON t.calendar_date >= p.campaign_start_date::DATE
      AND t.calendar_date <= CURRENT_DATE
  WHERE p.campaign_name NOT ILIKE '%Follow%Up%' -- remove follow ups with addition of stages
  AND p.lead_owner NOT IN ('Tim Riley', 'Kyle McQuillan')
  )
  
  , base_helper AS (
  SELECT DISTINCT 
  lead_id
  , lead_owner
  , acco_id 
  , campaign_name
  , campaign_start_date
  FROM base
  )
  
  , base_helper_final AS (
  SELECT DISTINCT 
  lead_id
  , lead_owner
  , acco_id 
  FROM base_helper
  )
  
  , lead_history AS (
  SELECT DISTINCT
  ld.lead_id 
  , ld.as_of_date 
  , ld.lead_owner
  , ld.acco_id
  , ld.customer_status
  , b.campaign_name 
  , b.campaign_start_date
  FROM fbg_analytics.vip.leads_daily AS ld
  INNER JOIN base AS b 
      ON ld.lead_id = b.lead_id 
      AND ld.as_of_date = b.date
  )
  
  , lead_status_history AS (
  SELECT DISTINCT 
  leadid AS lead_id
  , TO_TIMESTAMP_TZ(createddate, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM')::TIMESTAMP_NTZ AS createddate
  , newvalue AS status
  , oldvalue AS prev_status
  FROM fbg_source.salesforce.o_lead_history
  WHERE field = 'Status'
  )
  
  , lead_status_history_final AS (
  SELECT DISTINCT 
  lead_id 
  , createddate AS valid_from 
  , COALESCE(LEAD(createddate) OVER(PARTITION BY lead_id ORDER BY createddate), '9999-01-01'::TIMESTAMP) AS valid_to 
  , status 
  , prev_status
  FROM lead_status_history
  WHERE status != prev_status OR prev_status IS NULL
  )
  
  , account_bonus_extracts as (
      select
          a.acco_id,
          a.created,
          -- bc.bonus_campaign_id,
          -- bc.bonus_campaign_name,
          b.bonus_name,
          b.qual_bonus_pct,
          concat(round(b.qual_bonus_pct),'% Offer')::string as offer_selected,
          b.bonus_stakes_amount,
          b.bonus_stakes_amount / b.qual_bonus_pct * 100 as max_qual_deposit_amount,   
  
          CASE 
            WHEN regexp_substr(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              TO_NUMBER(CAST(REGEXP_SUBSTR(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) AS NUMBER(12,2)))
            ELSE NULL
          END as fancash_amount, 
          fancash_amount / bonus_stakes_amount as perc_max_deposit,
          fancash_amount / b.qual_bonus_pct * 100 as perc_max_deposit_1,
      
          a.state as account_bonus_state,
          a.modified as last_modified_time,
          
          CASE 
            WHEN regexp_substr(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              -- convert_timezone(
              TO_TIMESTAMP_NTZ(CAST(REGEXP_SUBSTR(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) AS NUMBER) / 1000)
            ELSE NULL
          END as opt_in_time
      from fbg_source.osb_source.account_bonuses a
      inner join base b 
          on a.bonus_campaign_id = b.bonus_campaign_id
          and a.acco_id = b.acco_id
  ),
  
  log_ins as (
      select
          b.acco_id,
          b.campaign_name,
          a.last_login_time,
          case when a.last_login_time >= b.campaign_start_date then 1 else 0 end has_logged_on
      from base as b 
      inner join fbg_source.osb_source.accounts as a
          on b.acco_id = a.id 
      where a.test = 0
  ),
  
  -- deposits as (
  --         SELECT a.acco_id
  --         , SUM(amount) AS deposits
  --         , min(a.completed_at) as deposit_time
  --         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
  --         INNER JOIN base b
  --             on a.acco_id = b.acco_id
  --             and a.completed_at >= b.bonus_campaign_start_date
  --         WHERE a.status = 'DEPOSIT_SUCCESS'
  --         GROUP BY all
  --     ),
  
  -- deposits_post_offer as (
  --         SELECT a.acco_id
  --         , a.completed_at::DATE AS date
  --         , SUM(amount) AS deposits_post_offer
  --         , min(a.completed_at) as deposit_time
  --         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
  --         INNER JOIN base_helper b
  --             on a.acco_id = b.acco_id
  --             and a.completed_at >= b.bonus_campaign_start_date
  --         WHERE a.status = 'DEPOSIT_SUCCESS'
  --         GROUP BY all
  --     ),
  
  deposits_post_offer as (
          SELECT a.acco_id 
          , a.date
          , b.campaign_name
          , SUM(a.final_deposit_amount) AS deposits_post_offer
          , MIN(a.date) AS deposit_time
          FROM fbg_analytics.vip.deposits_withdrawals a 
          INNER JOIN base_helper b 
              ON a.acco_id = b.acco_id
              AND a.date >= b.campaign_start_date::DATE
          GROUP BY ALL
  ),
  
  first_deposit_post_offer as (
          SELECT a.acco_id 
          , b.campaign_name
          , MIN(a.date) AS first_deposit_date_post_offer
          FROM fbg_analytics.vip.deposits_withdrawals a 
          INNER JOIN base_helper b 
              ON a.acco_id = b.acco_id
              AND a.date >= b.campaign_start_date::DATE
          WHERE a.deposit_amount > 0
          GROUP BY ALL
  ),
  
  first_deposit_time_post_offer as (
          SELECT a.transaction_account_id AS acco_id
          , b.campaign_name
          , a.trans_date_utc AS first_deposit_time_post_offer
          FROM fbg_analytics_engineering.transactions.transactions_mart AS a 
          INNER JOIN first_deposit_post_offer AS b 
              ON a.transaction_account_id = b.acco_id
              AND a.trans_date_utc::DATE = b.first_deposit_date_post_offer
              AND a.transaction_type = 'DEPOSIT'
          QUALIFY row_number() OVER (PARTITION BY a.transaction_account_id, b.campaign_name ORDER BY a.trans_date_utc ASC) = 1 -- first deposit timestamp
  ),
  
  -- last_deposit as (
  --         SELECT a.acco_id
  --         , max(convert_timezone('America/New_York',a.completed_at))::date as last_deposit_date
  --         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
  --         INNER JOIN base_helper b
  --             on a.acco_id = b.acco_id
  --         WHERE a.status = 'DEPOSIT_SUCCESS'
  --         GROUP BY all
  --     ),
  
  last_deposit as (
          SELECT a.acco_id 
          , MAX(a.date) AS last_deposit_date
          FROM fbg_analytics.vip.deposits_withdrawals a 
          INNER JOIN base_helper_final b 
              ON a.acco_id = b.acco_id
          WHERE final_deposit_amount > 0
          GROUP BY ALL
  ),
  
  
  -- withdrawals as (
  --         SELECT a.account_id AS acco_id, SUM(amount) AS withdrawals, min(a.completed_at) as next_withdrawal
  --         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
  --         INNER JOIN base b
  --             on a.account_id = b.acco_id
  --             and a.completed_at >= b.opt_in_time
  --         WHERE a.status = 'WITHDRAWAL_COMPLETED'
  --         GROUP BY all
  --     ),
  
  -- withdrawals_post_offer as (
  --         SELECT a.account_id AS acco_id
  --         , a.completed_at::DATE AS date
  --         , SUM(amount) AS withdrawals_post_offer
  --         , min(a.completed_at) as next_withdrawal
  --         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
  --         INNER JOIN base_helper b
  --             on a.account_id = b.acco_id
  --             and a.completed_at >= b.bonus_campaign_start_date
  --         WHERE a.status = 'WITHDRAWAL_COMPLETED'
  --         GROUP BY all
  --     ),
  
  withdrawals_post_offer as (
          SELECT a.acco_id 
          , a.date 
          , b.campaign_name
          , SUM(a.final_withdrawal_amount) AS withdrawals_post_offer
          , MIN(a.date) AS next_withdrawal
          FROM fbg_analytics.vip.deposits_withdrawals a 
          INNER JOIN base_helper b 
              ON a.acco_id = b.acco_id 
              AND a.date >= b.campaign_start_date::DATE
          GROUP BY ALL
  ),
  
  -- last_withdrawal as (
  --         SELECT a.account_id AS acco_id
  --         , max(convert_timezone('America/New_York',a.completed_at))::date as last_withdrawal_date
  --         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
  --         INNER JOIN base_helper b
  --             on a.account_id = b.acco_id
  --         WHERE a.status = 'WITHDRAWAL_COMPLETED'
  --         GROUP BY all
  --     )
  
  last_withdrawal as (
          SELECT a.acco_id 
          , MAX(a.date) AS last_withdrawal_date
          FROM fbg_analytics.vip.deposits_withdrawals a 
          INNER JOIN base_helper_final b 
              ON a.acco_id = b.acco_id 
          WHERE final_withdrawal_amount > 0
          GROUP BY ALL
  )
  
  
  -- oc_stake as (
  -- SELECT a.acco_id
  -- , sum(stake) AS oc_cash_stake
  -- FROM fbg_analytics_engineering.casino.casino_transactions_mart a
  -- INNER JOIN account_bonus_extracts b
  --     on a.acco_id = b.acco_id
  --     and a.placed_time_utc >= b.opt_in_time
  -- WHERE fund_type_id = 1
  -- GROUP BY ALL
  -- )
  
  -- , oc_metrics as (
  -- SELECT a.acco_id
  -- , sum(ngr) as oc_ngr
  -- , sum(expected_ngr) AS oc_engr
  -- FROM fbg_analytics_engineering.casino.casino_daily_settled_agg a
  -- INNER JOIN account_bonus_extracts b
  --     on a.acco_id = b.acco_id
  --     and a.settled_date_alk >= b.opt_in_time
  -- GROUP BY ALL 
  -- ) 
  
  -- , osb_metrics AS (
  -- SELECT 
  -- account_id as acco_id
  -- , sum(total_cash_stake_by_legs) AS osb_cash_stake
  -- , sum(total_ngr_by_legs) as osb_ngr
  -- , sum(expected_ngr_by_legs) AS osb_engr
  -- FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
  -- INNER JOIN account_bonus_extracts b
  --     on a.account_id = b.acco_id
  --     and a.wager_placed_time_utc >= b.opt_in_time
  -- WHERE is_test_wager = FALSE 
  -- AND wager_status = 'SETTLED'
  -- GROUP BY ALL
  -- ) 
  
  , oc_stake_post_offer as (
  SELECT a.acco_id
  , a.placed_time_alk::DATE AS date
  , b.campaign_name
  , sum(stake) AS oc_cash_stake_post_offer
  FROM fbg_analytics_engineering.casino.casino_transactions_mart a
  INNER JOIN base_helper b
      on a.acco_id = b.acco_id
      and a.placed_time_alk >= b.campaign_start_date
  WHERE fund_type_id = 1
  GROUP BY ALL
  )
  
  , first_oc_stake_post_offer as (
  SELECT a.acco_id
  , b.campaign_name
  , min(a.placed_time_utc) AS first_oc_cash_stake_time_post_offer
  FROM fbg_analytics_engineering.casino.casino_transactions_mart a
  INNER JOIN base_helper b
      on a.acco_id = b.acco_id
      and a.placed_time_utc >= b.campaign_start_date
  WHERE fund_type_id = 1
  AND stake > 0
  GROUP BY ALL
  )
  
  , oc_metrics_post_offer as (
  SELECT a.acco_id
  , a.settled_date_alk::DATE AS date
  , b.campaign_name
  , sum(ngr) as oc_ngr_post_offer
  , sum(expected_ngr) AS oc_engr_post_offer
  FROM fbg_analytics_engineering.casino.casino_daily_settled_agg a
  INNER JOIN base_helper b
      on a.acco_id = b.acco_id
      and a.settled_date_alk >= b.campaign_start_date
  GROUP BY ALL 
  ) 
  
  , osb_metrics_post_offer AS (
  SELECT 
  account_id as acco_id
  , a.wager_placed_time_alk::DATE AS date
  , b.campaign_name
  , sum(total_cash_stake_by_legs) AS osb_cash_stake_post_offer
  , sum(CASE WHEN wager_status = 'SETTLED' THEN total_ngr_by_legs END) as osb_ngr_post_offer
  , sum(CASE WHEN wager_status = 'SETTLED' THEN expected_ngr_by_legs END) AS osb_engr_post_offer
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
  INNER JOIN base_helper b
      on a.account_id = b.acco_id
      and a.wager_placed_time_alk >= b.campaign_start_date
  WHERE is_test_wager = FALSE 
  --AND wager_status = 'SETTLED'
  GROUP BY ALL
  )
  
  , first_osb_stake_post_offer AS (
  SELECT 
  account_id as acco_id
  , b.campaign_name
  , MIN(a.wager_placed_time_utc) AS first_osb_cash_stake_time_post_offer
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
  INNER JOIN base_helper b
      on a.account_id = b.acco_id
      and a.wager_placed_time_utc >= b.campaign_start_date
  WHERE is_test_wager = FALSE 
  AND total_cash_stake_by_legs > 0
  GROUP BY ALL
  )
  
  , osb_open_metrics_post_offer AS (
  SELECT 
  account_id as acco_id
  , sum(total_cash_stake_by_legs) AS osb_open_cash_stake
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
  INNER JOIN base_helper_final b
      on a.account_id = b.acco_id
  WHERE is_test_wager = FALSE 
  AND wager_status = 'ACCEPTED'
  GROUP BY ALL
  )
  
  , current_balance as (
          SELECT a.acco_id, balance as current_balance
          FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES a
          WHERE a.fund_type_id = 1
      )
  
  -- , next_direct_investment as (
  --     select 
  --         d.acco_id,
  --         di.groups as next_trigger,
  --         di.offer_date as next_di_offer_date,
  --         di.offer as next_di_offer,
  --         count(*) over (partition by di.acco_id) num_di_offers
      
  --     from base d 
  --     left join fbg_analytics.product_and_customer.direct_investments_history di
  --     on di.acco_id = d.acco_id
  --     and di.offer_date > d.bonus_campaign_start_date
  --     where 1=1
  --         and di.gets_offer = 'Y'
  --         --and offer_date > '2025-08-18'
  --         -- and offer_date < '2025-08-25'
  --     qualify row_number() over (partition by di.acco_id order by offer_date) = 1
  -- )
  
  , pre_offer_activity AS (
  SELECT DISTINCT 
  cvp.acco_id
  , b.campaign_name
  , b.campaign_start_date
  , SUM(COALESCE(osb_cash_handle, 0) + COALESCE(oc_cash_handle, 0)) AS cash_handle_90_days_pre_offer
  FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
  INNER JOIN base_helper AS b
      ON cvp.acco_id = b.acco_id
      AND cvp.date < DATE_TRUNC('DAY', b.campaign_start_date)
      AND cvp.date >= DATEADD(DAY, -90, DATE_TRUNC('DAY', b.campaign_start_date))
  -- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
  --     ON b.campaign_cohort_id = bc.bonus_campaign_id
  --     AND cvp.date < DATE_TRUNC('DAY', bc.bonus_campaign_start_date)
  --     AND cvp.date >= DATEADD(DAY, -90, DATE_TRUNC('DAY', bc.bonus_campaign_start_date))
  GROUP BY ALL
  )
  
  , post_offer_activity AS (
  SELECT DISTINCT 
  cvp.acco_id
  , cvp.date
  , b.campaign_name
  , b.campaign_start_date
  , SUM(COALESCE(customer_variable_profit, 0)) AS cvp_post_offer
  , SUM(COALESCE(ecustomer_variable_profit, 0)) AS ecvp_post_offer
  FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
  INNER JOIN base_helper AS b
      ON cvp.acco_id = b.acco_id
      AND cvp.date >= b.campaign_start_date
  -- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
  --     ON b.campaign_cohort_id = bc.bonus_campaign_id
  --     AND cvp.date >= bc.bonus_campaign_start_date
  GROUP BY ALL
  )
  
  , last_cash_active as (
  SELECT DISTINCT 
  cvp.acco_id
  , MAX(cvp.date) AS last_cash_active_date
  FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
  INNER JOIN base_helper_final AS b
      ON cvp.acco_id = b.acco_id
  -- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
  --     ON b.campaign_cohort_id = bc.bonus_campaign_id
  --     AND cvp.date >= bc.bonus_campaign_start_date
  WHERE cvp.osb_cash_handle > 0 OR cvp.oc_cash_handle > 0
  GROUP BY ALL
  )
  
  , tier_point_activity AS (
  SELECT DISTINCT
  c.acco_id 
  , b.campaign_name
  , SUM(f.tier_points_amount) AS tier_points_since_offer
  FROM FDE_FBG_INFO.FDE_FBG_INFO.TIER_POINTS_LEDGER_V AS f 
  INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART c 
      ON f.tenant_fan_id = c.tenant_fan_id
  INNER JOIN base_helper AS b
      ON c.acco_id = b.acco_id
      AND f.transaction_timestamp > b.campaign_start_date
  -- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
  --     ON b.campaign_cohort_id = bc.bonus_campaign_id
  --     AND f.transaction_timestamp > bc.bonus_campaign_start_date
  WHERE COALESCE(f.notes, '') != 'EOY-Rollover'
  GROUP BY ALL
  )
  
  , last_contacts AS (
  SELECT b.lead_id
  , MAX(CASE WHEN ld.total_comms_inbound > 0 THEN ld.as_of_date END) AS last_inbound_contact_date
  , MAX(CASE WHEN ld.total_comms_outbound > 0 THEN ld.as_of_date END) AS last_outbound_contact_date
  FROM fbg_analytics.vip.leads_daily AS ld
  INNER JOIN base_helper_final AS b 
      ON ld.lead_id = b.lead_id
  GROUP BY ALL
  )
  
  , contact_metrics AS (
  SELECT DISTINCT 
  b.lead_id
  , b.campaign_name
  , CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
  --, CONVERT_TIMEZONE('UTC', 'America/New_York', lc.message_date)::DATE AS date
  , SUM(inbound) AS total_comms_inbound
  , SUM(CASE WHEN message_type = 'Text' THEN inbound ELSE 0 END) AS texts_inbound
  , SUM(CASE WHEN message_type = 'Email' THEN inbound ELSE 0 END) AS emails_inbound
  , SUM(CASE WHEN message_type = 'Call' THEN inbound ELSE 0 END) AS calls_inbound
  , SUM(outbound) AS total_comms_outbound
  , SUM(CASE WHEN message_type = 'Text' THEN outbound ELSE 0 END) AS texts_outbound
  , SUM(CASE WHEN message_type = 'Email' THEN outbound ELSE 0 END) AS emails_outbound
  , SUM(CASE WHEN message_type = 'Call' THEN outbound ELSE 0 END) AS calls_outbound
  FROM fbg_analytics.vip.lead_contact_history AS lc
  INNER JOIN base_helper AS b 
      ON lc.lead_id = b.lead_id
      --AND lc.fbg_name = b.lead_owner
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE  >=  b.campaign_start_date::DATE
  GROUP BY 
  ALL
  )
  
  , contact_metrics_detailed AS (
  SELECT DISTINCT 
  b.campaign_name
  , CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::TIMESTAMP AS message_date 
  , lc.message_type
  , lc.outbound 
  , lc.inbound
  , lc.subject 
  , lc.description 
  , lc.lead_id 
  , lc.user_phone
  , lc.user_email
  , lc.fbg_owner_id 
  , lc.fbg_name 
  , lc.fbg_phone
  , lc.fbg_email
  FROM fbg_analytics.vip.lead_contact_history AS lc
  INNER JOIN base_helper AS b 
      ON lc.lead_id = b.lead_id
      --AND lc.fbg_name = b.lead_owner
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
  )
  
  , first_inbound_contact_metrics AS (
  SELECT DISTINCT 
  lead_id 
  , campaign_name 
  , MIN(message_date) AS first_inbound_contact_time_post_offer
  FROM contact_metrics_detailed
  WHERE inbound = 1
  GROUP BY ALL
  )
  
  , last_contact_metrics_lead_owner AS (
  SELECT DISTINCT 
  b.lead_id
  , b.campaign_name
  , MAX(CASE WHEN lc.outbound = 1 THEN CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE END) AS last_outbound_contact_date_lead_owner
  , MAX(CASE WHEN lc.outbound = 1 AND lc.message_type = 'Email' THEN CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE END) AS last_outbound_email_date_lead_owner
  FROM fbg_analytics.vip.lead_contact_history AS lc
  INNER JOIN lead_history AS b 
      ON lc.lead_id = b.lead_id
      AND lc.fbg_name = b.lead_owner
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE = b.as_of_date
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
  GROUP BY 
  ALL
  ) 
  
  , contact_metrics_lead_owner AS (
  SELECT DISTINCT 
  b.lead_id
  , b.campaign_name
  , CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
  , SUM(inbound) AS total_comms_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Text' THEN inbound ELSE 0 END) AS texts_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Email' THEN inbound ELSE 0 END) AS emails_inbound_lead_owner
  , SUM(CASE WHEN message_type = 'Call' THEN inbound ELSE 0 END) AS calls_inbound_lead_owner
  , SUM(outbound) AS total_comms_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Text' THEN outbound ELSE 0 END) AS texts_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Email' THEN outbound ELSE 0 END) AS emails_outbound_lead_owner
  , SUM(CASE WHEN message_type = 'Call' THEN outbound ELSE 0 END) AS calls_outbound_lead_owner
  FROM fbg_analytics.vip.lead_contact_history AS lc
  INNER JOIN lead_history AS b 
      ON lc.lead_id = b.lead_id
      AND lc.fbg_name = b.lead_owner
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE = b.as_of_date
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
  GROUP BY 
  ALL
  )
  
  , loyalty_tier_metrics AS (
  SELECT DISTINCT 
  f.acco_id
  , b.campaign_name
  , f.loyalty_tier AS loyalty_tier_campaign_start
  FROM fbg_analytics.product_and_customer.f1_attributes_audits AS f 
  INNER JOIN base_helper AS b 
      ON f.acco_id = b.acco_id 
      AND f.as_of_date = b.campaign_start_date::DATE
  )
  
  , email_days AS (
  SELECT DISTINCT
  b.lead_id
  , b.campaign_name
  , CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
  , MAX(IFF(outbound = 1 AND message_type = 'Email', 1, 0)) AS has_outbound_email
  , MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%President of VIP%', 1, 0)) AS has_herm_email
  , MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%Fanatics Fest%', 1, 0)) AS has_fanatics_fest_email
  , MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%Fanatics Head of VIP%', 1, 0)) AS has_rob_follow_up_email
  FROM fbg_analytics.vip.lead_contact_history AS lc
  INNER JOIN base_helper AS b 
      ON lc.lead_id = b.lead_id
      AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
  GROUP BY ALL
  )
  
  , hosting_metrics AS (
  SELECT DISTINCT 
  b.lead_id 
  , b.campaign_name 
  , b.acco_id 
  , h.as_of_date 
  , h.vip_host
  FROM fbg_analytics.vip.vip_host_lead_historical AS h 
  INNER JOIN base_helper AS b
      ON h.acco_id = b.acco_id 
      AND h.as_of_date >= b.campaign_start_date
  )
  
  , first_hosting_metrics AS (
  SELECT DISTINCT 
  b.lead_id 
  , b.campaign_name 
  , b.acco_id 
  , MIN(CASE WHEN h.vip_host IS NOT NULL THEN h.as_of_date END) AS first_hosted_date_since_campaign
  FROM fbg_analytics.vip.vip_host_lead_historical AS h 
  INNER JOIN base_helper AS b
      ON h.acco_id = b.acco_id 
      AND h.as_of_date >= b.campaign_start_date
  GROUP BY ALL
  )
  
  , final__ as (
  select distinct
      b.date,
      b.campaign_name,
      DATEDIFF(DAY, b.campaign_start_date::DATE, b.date) AS days_since_offer,
      DATEDIFF(WEEK, b.campaign_start_date::DATE, b.date) AS weeks_since_offer,
      DATEDIFF(WEEK, fdpo.first_deposit_date_post_offer, b.date) AS weeks_since_first_deposit_post_offer,
      DATEDIFF(DAY, fdpo.first_deposit_date_post_offer, b.date) AS days_since_first_deposit_post_offer,
      CASE WHEN days_since_offer <= 7 THEN TRUE ELSE FALSE END AS within_7_days_of_offer,
      CASE WHEN days_since_first_deposit_post_offer <= 7 THEN TRUE ELSE FALSE END AS within_7_days_of_first_deposit,
      CASE WHEN days_since_offer <= 7 THEN '0-7'
              WHEN days_since_offer > 7 AND days_since_offer <= 14 THEN '7-14'
              WHEN days_since_offer > 14 AND days_since_offer <= 21 THEN '14-21'
              WHEN days_since_offer > 21 AND days_since_offer <= 28 THEN '21-28'
              ELSE '28+' END AS date_cohort,
      b.lead_id,
      b.lead_source,
      CASE WHEN b.lead_source_detailed = 'Dynasty Rewards' THEN 'Dynasty Rewards'
           WHEN b.lead_source_detailed = 'Dave & Busters' THEN 'Dave & Busters'
           WHEN b.lead_source_detailed = 'Arbys' THEN 'Arbys' 
           WHEN b.lead_source_detailed = 'Trustly' THEN 'Trustly' ELSE b.lead_subsource END AS lead_subsource,
      b.is_lead_gen,
      lm.acco_id,
      b.campaign_start_date,
      lm.signup_date,
      case when lm.signup_date >= b.campaign_start_date::DATE THEN TRUE ELSE FALSE END AS is_new_signup,
      convert_timezone('UTC', 'America/New_York', l.last_login_time) as last_login_time_est, 
      cm.vip_host,
      ol.ownerid,
      CONCAT(ou.firstname, ' ', ou.lastname) as lead_owner,
      lh.lead_owner AS lead_owner_daily,
      cm.current_value_band,
      cm.f1_loyalty_tier,
      cm.f1_points_tier,
      cm.pseudonym,
      b.campaign_name AS campaign_name_,
      b.bonus_name,
      bc.bonus_campaign_id,
      bc.bonus_campaign_name,
      bc.qual_bonus_pct,
      bc.bonus_stakes_amount,
      bc.max_qual_deposit_amount,
      a.fancash_amount,
      a.perc_max_deposit,
      a.opt_in_time,
      a.last_modified_time,        
      a.account_bonus_state,
      a.offer_selected,
      --a.di_offer_name,
      -- case when account_bonus_state is null and has_logged_on = 0 then 'Not Logged In - Not Used' 
      --      when account_bonus_state is null and has_logged_on = 1 then 'Logged In - Not Used' 
      --      when account_bonus_state = 'OPT_IN' then 'Offer Selected'
      --      when account_bonus_state = 'EXECUTED' then 'DM Executed'
      -- else null end bonus_status,
      case when account_bonus_state = 'AVAILABLE' then 'Logged In - Not Used' 
           when account_bonus_state = 'OPT_IN' then 'Offer Selected'
           when account_bonus_state = 'EXECUTED' then 'DM Executed'
      else 'Not Logged In' end bonus_status,
      case when fancash_amount = bc.bonus_stakes_amount then 1 else 0 end maxed_out,
      -- dep.deposits,
      -- dep.deposit_time,
      deppo.deposits_post_offer,
      deppo.deposit_time as deposit_time_post_offer,
      fdpo.first_deposit_date_post_offer,
      -- wit.withdrawals,
      -- wit.next_withdrawal,
      witpo.withdrawals_post_offer,
      witpo.next_withdrawal as next_withdrawal_post_offer,
      CASE WHEN datediff('day',deppo.deposit_time, witpo.next_withdrawal) < 0 THEN 0 ELSE datediff('day',deppo.deposit_time, witpo.next_withdrawal) END as time_to_withdrawal,
      -- cs.oc_cash_stake,
      cspo.oc_cash_stake_post_offer,
      -- ocm.oc_ngr,
      ocmpo.oc_ngr_post_offer,
      -- ocm.oc_engr,
      ocmpo.oc_engr_post_offer,
      -- osm.osb_cash_stake,
      osmpo.osb_cash_stake_post_offer,
      -- osm.osb_ngr,
      osmpo.osb_ngr_post_offer,
      -- osm.osb_engr,
      osmpo.osb_engr_post_offer,
      cb.current_balance,
      oompo.osb_open_cash_stake,
      -- case when ndi.acco_id is not null then 1 else 0 end di_requalified,
      -- ndi.next_trigger,
      -- datediff(day, a.created, ndi.next_di_offer_date) days_to_new_offer,
      -- ndi.next_di_offer_date,
      -- ndi.next_di_offer,
      -- ndi.num_di_offers,
      initcap(cm.status) as account_status,
      coalesce(poa.cash_handle_90_days_pre_offer, 0) as cash_handle_90_days_pre_offer,
      coalesce(tpa.tier_points_since_offer, 0) as tier_points_since_offer,
      coalesce(deppo.deposits_post_offer, 0) - coalesce(witpo.withdrawals_post_offer, 0) as net_deposits_post_offer,
      coalesce(pooa.cvp_post_offer, 0) AS cvp_post_offer,
      coalesce(pooa.ecvp_post_offer, 0) AS ecvp_post_offer,
      lm.state,
      lm.status_match_submitted_time,
      lm.status_match_tier_name,
      lm.status_match_operator,
      lm.status_match_operator_tier,
      lm.status_match_trial_start,
      lm.status_match_status,
      sm.status_match_tier_points,
      w.wac,
      ld.last_deposit_date,
      lw.last_withdrawal_date,
      lca.last_cash_active_date,
      lc.last_inbound_contact_date,
      lc.last_outbound_contact_date,
      lcml.last_outbound_contact_date_lead_owner,
      lcml.last_outbound_email_date_lead_owner,
      lm.lead_status,
      conm.total_comms_inbound,
      conm.texts_inbound,
      conm.emails_inbound,
      conm.calls_inbound,
      conm.total_comms_outbound,
      conm.texts_outbound,
      conm.emails_outbound,
      conm.calls_outbound,
      conmlo.total_comms_inbound_lead_owner,
      conmlo.texts_inbound_lead_owner,
      conmlo.emails_inbound_lead_owner,
      conmlo.calls_inbound_lead_owner,
      conmlo.total_comms_outbound_lead_owner,
      conmlo.texts_outbound_lead_owner,
      conmlo.emails_outbound_lead_owner,
      conmlo.calls_outbound_lead_owner,
      ltm.loyalty_tier_campaign_start,
      case when (lm.acco_id is not null and cm.status = 'ACTIVE' and dq.acco_id is null and lm.lead_status != 'Disqualified') or (lm.acco_id is null and lm.rg_status = 'RG Passed - Name Cleared' and lm.lead_status != 'Disqualified') then true else false end as can_contact,
      case when (lh.acco_id is not null and lh.customer_status = 'ACTIVE' and dq.acco_id is null and lshf.status != 'Disqualified') or (lh.acco_id is null and lm.rg_status = 'RG Passed - Name Cleared' and lshf.status != 'Disqualified') then true else false end as can_contact_daily,
      case when lm.lead_status = 'Disqualified' then 'Lead Disqualified'
              when lm.acco_id is not null and (cm.status != 'ACTIVE' or dq.acco_id is not null) then 'Account Status Non-Active / Perm DQ'
              when lm.acco_id is null and coalesce(lm.rg_status, 'none') != 'RG Passed - Name Cleared' then 'Lead Not RG Cleared'
              else null end as can_contact_reason,
      case when lshf.status = 'Disqualified' then 'Lead Disqualified'
              when lh.acco_id is not null and (lh.customer_status != 'ACTIVE' or dq.acco_id is not null) then 'Account Status Non-Active / Perm DQ'
              when lh.acco_id is null and coalesce(lm.rg_status, 'none') != 'RG Passed - Name Cleared' then 'Lead Not RG Cleared'
              else null end as can_contact_reason_daily,
      case when coalesce(osb_cash_stake_post_offer, 0) + coalesce(oc_cash_stake_post_offer, 0) > 0 THEN 1 ELSE 0 END AS is_active,
      focs.first_oc_cash_stake_time_post_offer,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage',focs.first_oc_cash_stake_time_post_offer) AS first_oc_cash_stake_time_post_offer_alk,
      fosbs.first_osb_cash_stake_time_post_offer,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage', fosbs.first_osb_cash_stake_time_post_offer) AS first_osb_cash_stake_time_post_offer_alk,
      case when focs.first_oc_cash_stake_time_post_offer is not null or fosbs.first_osb_cash_stake_time_post_offer is not null then least(coalesce(focs.first_oc_cash_stake_time_post_offer, '9999-01-01'), coalesce(fosbs.first_osb_cash_stake_time_post_offer, '9999-01-01')) else null end as first_cash_stake_time_post_offer,
      CONVERT_TIMEZONE('UTC', 'America/Anchorage', first_cash_stake_time_post_offer) AS first_cash_stake_time_post_offer_alk,
      case when coalesce(deposits_post_offer, 0) > 0 THEN 1 ELSE 0 END AS has_deposit,
      fdt.first_deposit_time_post_offer,
      case when coalesce(total_comms_inbound, 0) > 0 THEN 1 ELSE 0 END AS has_response,
      fic.first_inbound_contact_time_post_offer,
      case when coalesce(emails_outbound_lead_owner, 0) > 0 THEN 1 ELSE 0 END AS has_outbound_email_lead_owner,
      case when coalesce(total_comms_outbound_lead_owner, 0) > 0 THEN 1 ELSE 0 END AS has_outbound_contact_lead_owner,
      ed.has_outbound_email,
      ed.has_herm_email,
      ed.has_fanatics_fest_email,
      ed.has_rob_follow_up_email,
      hm.vip_host AS vip_host_daily,
      fhm.first_hosted_date_since_campaign,
      datediff(DAY, b.campaign_start_date, fhm.first_hosted_date_since_campaign) as days_until_first_hosted
  from base b 
  inner join fbg_source.salesforce.o_lead ol 
  on b.lead_id = ol.id 
  left join fbg_p13n.promo_bronze_table.bonus_campaign_extracts bc 
  on b.bonus_campaign_id = bc.bonus_campaign_id
  inner join fbg_analytics.vip.lead_machine lm 
  on b.lead_id = lm.lead_id
  left join fbg_source.salesforce.o_user ou 
  on ol.ownerid = ou.id
  left join account_bonus_extracts a 
  on lm.acco_id = a.acco_id
  and b.bonus_name = a.bonus_name
  left join fbg_analytics_engineering.customers.customer_mart cm
  on cm.acco_id = lm.acco_id 
  left join log_ins l 
  on l.acco_id = lm.acco_id
  and b.campaign_name = l.campaign_name
  -- left join deposits dep
  -- on lm.acco_id = dep.acco_id
  left join deposits_post_offer deppo
  on lm.acco_id = deppo.acco_id
  and b.date = deppo.date
  and b.campaign_name = deppo.campaign_name
  -- left join withdrawals wit
  -- on lm.acco_id = wit.acco_id
  left join withdrawals_post_offer witpo
  on lm.acco_id = witpo.acco_id
  and b.date = witpo.date
  and b.campaign_name = deppo.campaign_name
  -- left join oc_stake cs
  -- on lm.acco_id = cs.acco_id
  -- left join oc_metrics ocm 
  -- on lm.acco_id = ocm.acco_id
  -- left join osb_metrics osm 
  -- on lm.acco_id = osm.acco_id
  left join oc_stake_post_offer cspo
  on lm.acco_id = cspo.acco_id
  and b.date = cspo.date
  and b.campaign_name = cspo.campaign_name
  left join oc_metrics_post_offer ocmpo 
  on lm.acco_id = ocmpo.acco_id
  and b.date = ocmpo.date
  and b.campaign_name = ocmpo.campaign_name
  left join osb_metrics_post_offer osmpo
  on lm.acco_id = osmpo.acco_id
  and b.date = osmpo.date
  and b.campaign_name = osmpo.campaign_name
  left join current_balance cb
  on lm.acco_id = cb.acco_id
  -- left join next_direct_investment ndi 
  -- on ndi.acco_id = lm.acco_id
  left join pre_offer_activity poa
  on lm.acco_id = poa.acco_id
  and b.campaign_name = poa.campaign_name
  left join tier_point_activity tpa
  on lm.acco_id = tpa.acco_id
  and b.campaign_name = tpa.campaign_name
  left join post_offer_activity pooa
  on lm.acco_id = pooa.acco_id
  and b.date = pooa.date
  and b.campaign_name = pooa.campaign_name
  left join fbg_analytics.vip.vip_wac_historical w
  on lm.acco_id = w.acco_id 
  and w.iscurrentweek = 1
  left join last_deposit ld
  on lm.acco_id = ld.acco_id
  left join last_withdrawal lw 
  on lm.acco_id = lw.acco_id
  left join last_cash_active lca
  on lm.acco_id = lca.acco_id
  left join last_contacts lc 
  on b.lead_id = lc.lead_id
  left join contact_metrics conm 
  on b.lead_id = conm.lead_id
  and b.date = conm.date
  and b.campaign_name = conm.campaign_name
  left join contact_metrics_lead_owner conmlo
  on b.lead_id = conmlo.lead_id
  and b.date = conmlo.date
  and b.campaign_name = conmlo.campaign_name
  left join loyalty_tier_metrics ltm 
  on lm.acco_id = ltm.acco_id
  and b.campaign_name = ltm.campaign_name
  left join fbg_analytics.product_and_customer.status_match sm 
  on lm.acco_id = sm.acco_id
  left join fbg_analytics.vip.vip_disqualified dq 
  on lm.acco_id = dq.acco_id
  left join first_deposit_post_offer fdpo
  on lm.acco_id = fdpo.acco_id
  and b.campaign_name = fdpo.campaign_name
  and b.date >= first_deposit_date_post_offer
  left join osb_open_metrics_post_offer oompo
  on lm.acco_id = oompo.acco_id
  left join email_days ed 
  on b.lead_id = ed.lead_id 
  and b.date = ed.date 
  and b.campaign_name = ed.campaign_name
  left join lead_history lh 
  on b.lead_id = lh.lead_id 
  and b.date = lh.as_of_date
  and b.campaign_name = lh.campaign_name
  left join last_contact_metrics_lead_owner lcml
  on b.lead_id = lcml.lead_id
  and b.campaign_name = lcml.campaign_name
  left join lead_status_history_final lshf
  on b.lead_id = lshf.lead_id 
  and lshf.valid_from <= b.date 
  and lshf.valid_to > b.date
  left join hosting_metrics hm 
  on b.acco_id = hm.acco_id
  and b.campaign_name = hm.campaign_name
  and b.date = hm.as_of_date
  left join first_hosting_metrics fhm 
  on b.acco_id = fhm.acco_id
  and b.campaign_name = fhm.campaign_name
  left join first_deposit_time_post_offer fdt
  on b.acco_id = fdt.acco_id
  and b.campaign_name = fdt.campaign_name
  left join first_oc_stake_post_offer focs 
  on b.acco_id = focs.acco_id
  and b.campaign_name = focs.campaign_name
  left join first_osb_stake_post_offer fosbs 
  on b.acco_id = fosbs.acco_id
  and b.campaign_name = fosbs.campaign_name
  left join first_inbound_contact_metrics fic 
  on b.lead_id = fic.lead_id
  and b.campaign_name = fic.campaign_name
  )
  
  
  , cumulative AS (
  SELECT DISTINCT
    *,
    MAX(IFF(is_active=1, 1, 0))   OVER (PARTITION BY lead_id, campaign_name ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_active,
    MAX(IFF(has_deposit=1, 1, 0)) OVER (PARTITION BY lead_id, campaign_name ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_deposit,
    MAX(IFF(has_response=1, 1, 0)) OVER (PARTITION BY lead_id, campaign_name ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_response
  FROM final__
  )
  
  , stage_0_start AS (
  SELECT DISTINCT 
  lead_id 
  , campaign_name
  , 'Organic' AS stage_type
  , MIN(date) AS stage_0_start_date
  FROM final__
  GROUP BY ALL
  )
  
  , stage_1_start AS (
  SELECT DISTINCT 
  lead_id 
  , campaign_name
  , 'Organic' AS stage_type
  , MIN(date) AS stage_1_start_date
  FROM final__
  WHERE has_outbound_contact_lead_owner = 1
  --WHERE has_outbound_email_lead_owner = 1
  GROUP BY ALL
  )
  
  -- , stage_2_candidates AS (
  -- SELECT DISTINCT 
  -- c.lead_id 
  -- , c.date AS stage_2_candidate_date 
  -- FROM cumulative AS c 
  -- INNER JOIN stage_1_start AS s 
  --     ON c.lead_id = s.lead_id 
  -- WHERE c.has_outbound_email_lead_owner = 1
  -- )
  
  , stage_1_cumulative AS (
  SELECT DISTINCT 
  c.lead_id
  , c.campaign_name
  , c.cumulative_active AS stage_1_cumulative_active
  , c.cumulative_deposit AS stage_1_cumulative_deposit
  , c.cumulative_response AS stage_1_cumulative_response
  FROM cumulative AS c 
  INNER JOIN stage_1_start AS s 
      ON c.lead_id = s.lead_id 
      AND c.date = s.stage_1_start_date
  )
  
  , stage_2_start AS (
  SELECT DISTINCT
  c.lead_id
  , c.campaign_name
  , MIN(c.date) AS stage_2_start_date
  FROM cumulative AS c
  INNER JOIN stage_1_start AS s1
      ON c.lead_id = s1.lead_id
      AND c.campaign_name = s1.campaign_name
  INNER JOIN stage_1_cumulative AS s1c 
      ON c.lead_id = s1c.lead_id
      AND c.campaign_name = s1c.campaign_name
  WHERE c.cumulative_active = s1c.stage_1_cumulative_active   -- no new active since s1 start
  AND c.cumulative_deposit = s1c.stage_1_cumulative_deposit  -- no new deposit since s1 start
  AND c.cumulative_response = s1c.stage_1_cumulative_response -- no new response since s1 start
  AND c.date > s1.stage_1_start_date -- strictly after stage 1 start
  AND (c.has_outbound_contact_lead_owner = 1 OR c.has_rob_follow_up_email = 1) -- lead owner followed up
  --AND (c.has_outbound_email_lead_owner = 1 OR c.has_rob_follow_up_email = 1) -- lead owner followed up via email
  AND c.cumulative_active = 0 -- not active
  AND c.cumulative_deposit = 0 -- not deposited
  AND c.cumulative_response = 0 -- not responded
  GROUP BY 1,2
  )
  
  , stage_2_override AS (
  SELECT DISTINCT 
  c.lead_id 
  , c.campaign_name 
  , MIN(c.date) AS stage_2_start_date_override
  FROM cumulative AS c
  WHERE c.has_rob_follow_up_email = 1
  GROUP BY ALL 
  )
  
  , stage_2_start_final AS (
  SELECT DISTINCT 
  c.lead_id
  , c.campaign_name
  -- , CASE WHEN COALESCE(s2.stage_2_start_date_override, '9999-01-01') < COALESCE(s1.stage_2_start_date, '9999-01-01') THEN 'Override' ELSE 'Organic' END AS stage_type
  , CASE WHEN COALESCE(s1.stage_2_start_date, '9999-01-01') <= COALESCE(s2.stage_2_start_date_override, '9999-01-01') THEN 'Organic' ELSE 'Override' END AS stage_type
  , LEAST(COALESCE(s1.stage_2_start_date, '9999-01-01'), COALESCE(s2.stage_2_start_date_override, '9999-01-01')) AS stage_2_start_date
  FROM cumulative AS c 
  LEFT JOIN stage_2_start AS s1
      ON c.lead_id = s1.lead_id 
      AND c.campaign_name = s1.campaign_name
  LEFT JOIN stage_2_override AS s2
      ON c.lead_id = s2.lead_id 
      AND c.campaign_name = s2.campaign_name
  GROUP BY ALL
  )
  
  , stage_2_cumulative AS (
  SELECT DISTINCT 
  c.lead_id
  , c.campaign_name
  , c.cumulative_active AS stage_2_cumulative_active
  , c.cumulative_deposit AS stage_2_cumulative_deposit
  , c.cumulative_response AS stage_2_cumulative_response
  FROM cumulative AS c 
  INNER JOIN stage_2_start_final AS s 
      ON c.lead_id = s.lead_id 
      AND c.campaign_name = s.campaign_name
      AND c.date = s.stage_2_start_date
  )
  
  , stage_3_start AS (
  SELECT DISTINCT
  c.lead_id
  , c.campaign_name
  , MIN(c.date) AS stage_3_start_date
  FROM cumulative AS c
  INNER JOIN stage_2_start_final AS s2
      ON c.lead_id = s2.lead_id
      AND c.campaign_name = s2.campaign_name
  INNER JOIN stage_2_cumulative AS s2c 
      ON c.lead_id = s2c.lead_id
      AND c.campaign_name = s2c.campaign_name
  WHERE c.cumulative_active = s2c.stage_2_cumulative_active   -- no new active since s2 start
  AND c.cumulative_deposit = s2c.stage_2_cumulative_deposit  -- no new deposit since s2 start
  AND c.cumulative_response = s2c.stage_2_cumulative_response -- no new response since s2 start
  AND c.date > s2.stage_2_start_date -- strictly after stage 2 start
  AND c.has_herm_email = 1 -- herm followed up via email
  GROUP BY 1,2
  )
  
  , stage_3_override AS (
  SELECT DISTINCT 
  c.lead_id 
  , c.campaign_name 
  , MIN(c.date) AS stage_3_start_date_override
  FROM cumulative AS c
  WHERE c.has_herm_email = 1
  GROUP BY ALL 
  )
  
  , stage_3_start_final AS (
  SELECT DISTINCT 
  c.lead_id
  , c.campaign_name 
  -- , CASE WHEN COALESCE(s2.stage_3_start_date_override, '9999-01-01') < COALESCE(s1.stage_3_start_date, '9999-01-01') THEN 'Override' ELSE 'Organic' END AS stage_type
  , CASE WHEN COALESCE(s1.stage_3_start_date, '9999-01-01') <= COALESCE(s2.stage_3_start_date_override, '9999-01-01') THEN 'Organic' ELSE 'Override' END AS stage_type
  , LEAST(COALESCE(s1.stage_3_start_date, '9999-01-01'), COALESCE(s2.stage_3_start_date_override, '9999-01-01')) AS stage_3_start_date
  FROM cumulative AS c 
  LEFT JOIN stage_3_start AS s1
      ON c.lead_id = s1.lead_id 
      AND c.campaign_name = s1.campaign_name
  LEFT JOIN stage_3_override AS s2
      ON c.lead_id = s2.lead_id 
      AND c.campaign_name = s2.campaign_name
  GROUP BY ALL
  )
  
  , stage_3_cumulative AS (
  SELECT DISTINCT 
  c.lead_id 
  , c.campaign_name
  , c.cumulative_active AS stage_3_cumulative_active
  , c.cumulative_deposit AS stage_3_cumulative_deposit
  , c.cumulative_response AS stage_3_cumulative_response
  FROM cumulative AS c 
  INNER JOIN stage_3_start_final AS s 
      ON c.lead_id = s.lead_id 
      AND c.campaign_name = s.campaign_name
      AND c.date = s.stage_3_start_date
  )
  
  , stage_4_start AS (
  SELECT DISTINCT
  c.lead_id
  , c.campaign_name
  , 'Organic' AS stage_type
  , MIN(c.date) AS stage_4_start_date
  FROM cumulative AS c
  INNER JOIN stage_3_start_final AS s3
      ON c.lead_id = s3.lead_id
      AND c.campaign_name = s3.campaign_name
  INNER JOIN stage_3_cumulative AS s3c 
      ON c.lead_id = s3c.lead_id
      AND c.campaign_name = s3c.campaign_name
  WHERE c.cumulative_active = s3c.stage_3_cumulative_active   -- no new active since s3 start
  AND c.cumulative_deposit = s3c.stage_3_cumulative_deposit  -- no new deposit since s3 start
  AND c.cumulative_response = s3c.stage_3_cumulative_response -- no new response since s3 start
  AND c.date > s3.stage_3_start_date -- strictly after stage 3 start
  AND c.has_fanatics_fest_email = 1 -- final FF email
  GROUP BY 1,2
  )
  
  
  , stage_summary AS (
  SELECT DISTINCT f.*
  , s0.stage_0_start_date
  , s1.stage_1_start_date
  , CASE WHEN s2.stage_2_start_date != '9999-01-01' THEN s2.stage_2_start_date ELSE NULL END AS stage_2_start_date
  , CASE WHEN s3.stage_3_start_date != '9999-01-01' THEN s3.stage_3_start_date ELSE NULL END AS stage_3_start_date
  , s4.stage_4_start_date
  , CASE
        WHEN s4.stage_4_start_date IS NOT NULL AND f.date >= s4.stage_4_start_date THEN 'Stage 4'
        WHEN s3.stage_3_start_date IS NOT NULL AND f.date >= s3.stage_3_start_date THEN 'Stage 3'
        WHEN s2.stage_2_start_date IS NOT NULL AND f.date >= s2.stage_2_start_date THEN 'Stage 2'
        WHEN s1.stage_1_start_date IS NOT NULL AND f.date >= s1.stage_1_start_date THEN 'Stage 1'
        WHEN f.date >= s0.stage_0_start_date THEN 'Stage 0'
        ELSE NULL END AS stage
  , CASE
        WHEN s4.stage_4_start_date IS NOT NULL AND f.date >= s4.stage_4_start_date THEN s4.stage_type
        WHEN s3.stage_3_start_date IS NOT NULL AND f.date >= s3.stage_3_start_date THEN s3.stage_type
        WHEN s2.stage_2_start_date IS NOT NULL AND f.date >= s2.stage_2_start_date THEN s2.stage_type
        WHEN s1.stage_1_start_date IS NOT NULL AND f.date >= s1.stage_1_start_date THEN s1.stage_type
        WHEN f.date >= s0.stage_0_start_date THEN s0.stage_type
        ELSE NULL END AS stage_type
  FROM final__ AS f 
  INNER JOIN stage_0_start AS s0 
      ON f.lead_id = s0.lead_id
      AND f.campaign_name = s0.campaign_name
  LEFT JOIN stage_1_start AS s1 
      ON f.lead_id = s1.lead_id
      AND f.campaign_name = s1.campaign_name
  LEFT JOIN stage_2_start_final AS s2 
      ON f.lead_id = s2.lead_id
      AND f.campaign_name = s2.campaign_name
  LEFT JOIN stage_3_start_final AS s3
      ON f.lead_id = s3.lead_id
      AND f.campaign_name = s3.campaign_name
  LEFT JOIN stage_4_start AS s4 
      ON f.lead_id = s4.lead_id
      AND f.campaign_name = s4.campaign_name
  )
  
  , stage_rollup AS (
  SELECT DISTINCT 
  lead_id,
  campaign_name, 
  
  /* Stage 0 */
  MAX(IFF(stage = 'Stage 0' AND (is_active=1 OR has_deposit=1 OR has_response=1), 1, 0)) AS engaged_in_stage_0,
  MAX(IFF(stage = 'Stage 0', IFF(can_contact,1,0), NULL)) AS can_contact_stage_0,
  -- MAX(IFF(stage = 'Stage 0', IFF(has_outbound_email_lead_owner=1,1,0), NULL)) AS owner_email_sent_stage_0,
  MAX(IFF(stage = 'Stage 0', IFF(has_outbound_contact_lead_owner=1,1,0), NULL)) AS owner_contact_sent_stage_0,
  
  /* Stage 1 window: from stage_1_start_date up to (but not incl) stage_2_start_date */
  MAX(IFF(stage = 'Stage 1' AND (is_active=1 OR has_deposit=1 OR has_response=1), 1, 0)) AS engaged_in_stage_1,
  MAX(IFF(stage = 'Stage 1', IFF(can_contact,1,0), NULL)) AS can_contact_stage_1,
  -- MAX(IFF(stage = 'Stage 1', IFF(has_outbound_email_lead_owner=1,1,0), NULL)) AS owner_email_sent_stage_1,
  MAX(IFF(stage = 'Stage 1', IFF(has_outbound_contact_lead_owner=1,1,0), NULL)) AS owner_contact_sent_stage_1,
  
  
  /* Stage 2 */
  MAX(IFF(stage = 'Stage 2' AND (is_active=1 OR has_deposit=1 OR has_response=1), 1, 0)) AS engaged_in_stage_2,
  MAX(IFF(stage = 'Stage 2', IFF(can_contact,1,0), NULL)) AS can_contact_stage_2,
  -- MAX(IFF(stage = 'Stage 2', IFF(has_rob_follow_up_email=1 OR has_outbound_email_lead_owner=1,1,0), NULL)) AS owner_email_sent_stage_2,
  MAX(IFF(stage = 'Stage 2', IFF(has_rob_follow_up_email=1 OR has_outbound_contact_lead_owner=1,1,0), NULL)) AS owner_contact_sent_stage_2,
  
  
  /* Stage 3 */
  MAX(IFF(stage = 'Stage 3' AND (is_active=1 OR has_deposit=1 OR has_response=1), 1, 0)) AS engaged_in_stage_3,
  MAX(IFF(stage = 'Stage 3', IFF(can_contact,1,0), NULL)) AS can_contact_stage_3,
  MAX(IFF(stage = 'Stage 3', IFF(has_herm_email=1,1,0), NULL)) AS owner_email_sent_stage_3
  
  FROM stage_summary 
  GROUP BY ALL
  )
  
  , stage_dates AS (
  SELECT DISTINCT 
  lead_id 
  , campaign_name
  , stage_0_start_date
  , stage_1_start_date
  , stage_2_start_date
  , stage_3_start_date
  , stage_4_start_date
  FROM stage_summary
  )
  
  , enagaged_dates AS (
  SELECT DISTINCT 
  lead_id 
  , campaign_name 
  , first_cash_stake_time_post_offer
  , first_deposit_time_post_offer
  , first_inbound_contact_time_post_offer
  FROM stage_summary
  )
  
  , stage_1_message_trigger AS (
  SELECT DISTINCT 
  s.*
  , c.message_type AS stage_1_message_type_trigger
  FROM contact_metrics_detailed AS c 
  INNER JOIN stage_dates AS s
      ON c.lead_id = s.lead_id 
      AND c.campaign_name = s.campaign_name 
      AND c.message_date::DATE = s.stage_1_start_date 
  WHERE c.outbound = 1
  QUALIFY row_number() OVER (PARTITION BY c.lead_id, c.campaign_name ORDER BY c.message_date ASC) = 1 -- first message to trigger stage 1
  )
  
  , stage_2_message_trigger AS (
  SELECT DISTINCT 
  s.*
  , c.message_type AS stage_2_message_type_trigger
  FROM contact_metrics_detailed AS c 
  INNER JOIN stage_dates AS s
      ON c.lead_id = s.lead_id 
      AND c.campaign_name = s.campaign_name 
      AND c.message_date::DATE = s.stage_2_start_date 
  WHERE c.outbound = 1
  QUALIFY row_number() OVER (PARTITION BY c.lead_id, c.campaign_name ORDER BY c.message_date ASC) = 1 -- first message to trigger stage 2
  )
  
  , messages_first_time_deposit AS (
  SELECT DISTINCT
  ed.*
  , SUM(c.outbound) AS messages_until_first_time_deposit
  FROM contact_metrics_detailed AS c 
  INNER JOIN enagaged_dates AS ed
      ON c.lead_id = ed.lead_id 
      AND c.campaign_name = ed.campaign_name 
      AND c.message_date::TIMESTAMP < ed.first_deposit_time_post_offer
      AND c.outbound = 1
  GROUP BY ALL
  )
  
  , messages_first_time_cash_stake AS (
  SELECT DISTINCT
  ed.*
  , SUM(c.outbound) AS messages_until_first_time_cash_stake
  FROM contact_metrics_detailed AS c 
  INNER JOIN enagaged_dates AS ed
      ON c.lead_id = ed.lead_id 
      AND c.campaign_name = ed.campaign_name 
      AND c.message_date::TIMESTAMP < ed.first_cash_stake_time_post_offer
      AND c.outbound = 1
  GROUP BY ALL
  )
  
  , messages_first_time_inbound_contact AS (
  SELECT DISTINCT
  ed.*
  , SUM(c.outbound) AS messages_until_first_time_inbound_contact
  FROM contact_metrics_detailed AS c 
  INNER JOIN enagaged_dates AS ed
      ON c.lead_id = ed.lead_id 
      AND c.campaign_name = ed.campaign_name 
      AND c.message_date::TIMESTAMP < ed.first_inbound_contact_time_post_offer
      AND c.outbound = 1
  GROUP BY ALL
  )
  
  , blockers AS (
  SELECT DISTINCT
  ss.lead_id,
  ss.campaign_name,
  
  /* Stage 0 -> Stage 1 */
  CASE
  WHEN ss.stage_0_start_date IS NULL THEN 'Never entered Stage 0'
  WHEN ss.stage_1_start_date IS NOT NULL THEN NULL
  WHEN sr.can_contact_stage_0 = 0 THEN 'Can Contact = false'
  --WHEN COALESCE(sr.owner_email_sent_stage_0,0) = 0 THEN 'Lead owner did not send email (Stage 0)'
  ELSE 'Lead owner did not send contact (Stage 0)'
  END AS why_no_stage_1,
  
  /* Stage 1 -> Stage 2 */
  CASE
  WHEN ss.stage_1_start_date IS NULL THEN 'Never entered Stage 1'
  WHEN ss.stage_2_start_date IS NOT NULL THEN NULL
  WHEN sr.engaged_in_stage_1 = 1 THEN 'Engaged in Stage 1'
  WHEN sr.can_contact_stage_1 = 0 THEN 'Can Contact = false'
  --WHEN COALESCE(sr.owner_email_sent_stage_1,0) = 0 THEN 'Lead owner did not send email (Stage 1)'
  ELSE 'Lead owner did not send follow up contact (Stage 1)'
  END AS why_no_stage_2,
  
  /* Stage 2 -> Stage 3 */
  CASE
  WHEN ss.stage_2_start_date IS NULL THEN 'Never entered Stage 2'
  WHEN ss.stage_3_start_date IS NOT NULL THEN NULL
  WHEN sr.engaged_in_stage_2 = 1 THEN 'Engaged in Stage 2'
  WHEN sr.can_contact_stage_2 = 0 THEN 'Can Contact = false'
  --WHEN COALESCE(sr.owner_email_sent_stage_2,0) = 0 THEN 'Lead owner did not send email (Stage 2)'
  ELSE 'Did not receive Herm email (Stage 2)'
  END AS why_no_stage_3,
  
  /* Stage 3 -> Stage 4 */
  CASE
  WHEN ss.stage_3_start_date IS NULL THEN 'Never entered Stage 3'
  WHEN ss.stage_4_start_date IS NOT NULL THEN NULL
  WHEN sr.engaged_in_stage_3 = 1 THEN 'Engaged in Stage 3'
  WHEN sr.can_contact_stage_3 = 0 THEN 'Can Contact = false'
  --WHEN COALESCE(sr.owner_email_sent_stage_3,0) = 0 THEN 'Lead owner did not send email (Stage 3)'
  ELSE 'Did not receive Fanatics Fest email (Stage 3)'
  END AS why_no_stage_4
  
  FROM stage_dates ss
  LEFT JOIN stage_rollup sr
  ON ss.lead_id = sr.lead_id
  AND ss.campaign_name = sr.campaign_name
  )
  
  --, last as (
  SELECT ss.*
  , CASE WHEN ss.date = ss.stage_1_start_date AND COALESCE(ss.emails_outbound, 0) > 0 THEN 1 ELSE 0 END AS successful_email_stage_1
  , CASE WHEN ss.date = ss.stage_2_start_date AND COALESCE(ss.emails_outbound, 0) > 0 THEN 1 ELSE 0 END AS successful_email_stage_2
  , CASE WHEN ss.date = ss.stage_3_start_date AND COALESCE(ss.emails_outbound, 0) > 0 THEN 1 ELSE 0 END AS successful_email_stage_3
  , mftd.messages_until_first_time_deposit
  , mftcs.messages_until_first_time_cash_stake
  , mftic.messages_until_first_time_inbound_contact
  , s1.stage_1_message_type_trigger
  , s2.stage_2_message_type_trigger
  , CASE WHEN ss.stage_3_start_date IS NOT NULL THEN 'Email' END AS stage_3_message_type_trigger
  , CASE WHEN ss.stage_4_start_date IS NOT NULL THEN 'Email' END AS stage_4_message_type_trigger
  , CASE
      WHEN ss.stage = 'Stage 0' THEN b.why_no_stage_1
      WHEN ss.stage = 'Stage 1' THEN b.why_no_stage_2
      WHEN ss.stage = 'Stage 2' THEN b.why_no_stage_3
      WHEN ss.stage = 'Stage 3' THEN b.why_no_stage_4
    END AS why_not_next_stage
  FROM stage_summary AS ss 
  LEFT JOIN blockers AS b 
      ON ss.lead_id = b.lead_id 
      AND ss.campaign_name = b.campaign_name
  LEFT JOIN stage_1_message_trigger AS s1 
      ON ss.lead_id = s1.lead_id
      AND ss.campaign_name = s1.campaign_name
  LEFT JOIN stage_2_message_trigger AS s2 
      ON ss.lead_id = s2.lead_id
      AND ss.campaign_name = s2.campaign_name
  LEFT JOIN messages_first_time_deposit AS mftd
      ON ss.lead_id = mftd.lead_id
      AND ss.campaign_name = mftd.campaign_name
  LEFT JOIN messages_first_time_cash_stake AS mftcs
      ON ss.lead_id = mftcs.lead_id
      AND ss.campaign_name = mftcs.campaign_name
  LEFT JOIN messages_first_time_inbound_contact AS mftic
      ON ss.lead_id = mftic.lead_id
      AND ss.campaign_name = mftic.campaign_name
  WHERE ss.lead_id IS NOT NULL
  AND NOT (ss.stage = 'Stage 0' AND ss.can_contact = FALSE)
  --
) "Custom SQL Query"
