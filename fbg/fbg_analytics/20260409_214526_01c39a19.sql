-- Query ID: 01c39a19-0212-6e7d-24dd-0703193aa787
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:45:26.019000+00:00
-- Elapsed: 58354ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."ACQUISITION_BONUS_NAME" AS "ACQUISITION_BONUS_NAME",
  "Custom SQL Query"."ACQUISITION_PROMOTION_CODE_ON_REGISTRATION" AS "ACQUISITION_PROMOTION_CODE_ON_REGISTRATION",
  "Custom SQL Query"."ACQUISITION_SUB_CHANNEL" AS "ACQUISITION_SUB_CHANNEL",
  "Custom SQL Query"."BANKS" AS "BANKS",
  "Custom SQL Query"."BET_ID" AS "BET_ID",
  "Custom SQL Query"."DECISION" AS "DECISION",
  "Custom SQL Query"."DEPOSIT_AMOUNT" AS "DEPOSIT_AMOUNT",
  "Custom SQL Query"."DEVICE_DECISION" AS "DEVICE_DECISION",
  "Custom SQL Query"."DEVICE_TYPE" AS "DEVICE_TYPE",
  "Custom SQL Query"."DOCV_DECISION" AS "DOCV_DECISION",
  "Custom SQL Query"."EMAIL_SCORE" AS "EMAIL_SCORE",
  "Custom SQL Query"."FIRST_SPORTS" AS "FIRST_SPORTS",
  "Custom SQL Query"."FRAUD_DECISION" AS "FRAUD_DECISION",
  "Custom SQL Query"."FRAUD_MODEL_VERSION" AS "FRAUD_MODEL_VERSION",
  "Custom SQL Query"."FRAUD_SCORE" AS "FRAUD_SCORE",
  "Custom SQL Query"."GEO_STATE" AS "GEO_STATE",
  "Custom SQL Query"."KYC_DATE_EST" AS "KYC_DATE_EST",
  "Custom SQL Query"."KYC_DECISION" AS "KYC_DECISION",
  "Custom SQL Query"."KYC_STATE" AS "KYC_STATE",
  "Custom SQL Query"."NAME_PHONE_SCORE" AS "NAME_PHONE_SCORE",
  "Custom SQL Query"."ORIGIN_CODE" AS "ORIGIN_CODE",
  "Custom SQL Query"."PHONE_DECISION" AS "PHONE_DECISION",
  "Custom SQL Query"."PHONE_SCORE" AS "PHONE_SCORE",
  "Custom SQL Query"."PLACED_TIME_EST" AS "PLACED_TIME_EST",
  "Custom SQL Query"."REGISTRATION_DATE_EST" AS "REGISTRATION_DATE_EST",
  "Custom SQL Query"."WATCHLIST_DECISION" AS "WATCHLIST_DECISION",
  "Custom SQL Query"."WITHDRAWAL_AMOUNT" AS "WITHDRAWAL_AMOUNT"
FROM (
  WITH total_details AS (
  
  WITH details  AS (
  
  
  SELECT
      x.account_id,
      x.origin_code,
      x.decision,
      --x.extra_details,
    -- Decisions
    TRY_PARSE_JSON(extra_details):fraud:decision::STRING              AS fraud_decision,
    TRY_PARSE_JSON(extra_details):kycPlus:decision::STRING            AS kyc_decision,
    TRY_PARSE_JSON(extra_details):phoneRisk:decision::STRING          AS phone_decision,
    TRY_PARSE_JSON(extra_details):deviceRisk:decision::STRING         AS device_decision,
    TRY_PARSE_JSON(extra_details):globalWatchlist:decision::STRING    AS watchlist_decision,
   -- TRY_PARSE_JSON(extra_details):alerts:decision::STRING              AS alerts_decision,
    TRY_PARSE_JSON(extra_details):documentVerification:decision::STRING  AS docv_decision,
    -- TRY_PARSE_JSON(extra_details):phoneRisk:decision::STRING          AS phone_decision,
    -- TRY_PARSE_JSON(extra_details):deviceRisk:decision::STRING         AS device_decision,
    -- TRY_PARSE_JSON(extra_details):globalWatchlist:decision::STRING    AS watchlist_decision,
    
    -- Fraud score: Revised
    CASE WHEN origin_code = 'SOCURE_RISKOS' THEN TRY_PARSE_JSON(extra_details):fraud:scores[0]:score::FLOAT     
                                            ELSE TRY_PARSE_JSON(extra_details):fraud:fraudScores[0]:score::FLOAT 
                                            END AS fraud_score,
    CASE WHEN origin_code = 'SOCURE_RISKOS' THEN TRY_PARSE_JSON(extra_details):fraud:scores[0]:version::STRING    
                                            ELSE TRY_PARSE_JSON(extra_details):fraud:fraudScores[0]:version::STRING 
                                            END AS fraud_model_version,
    
    -- Fraud score
    --TRY_PARSE_JSON(extra_details):fraud:fraudScores[0]:score::FLOAT     AS fraud_score,
    --TRY_PARSE_JSON(extra_details):fraud:fraudScores[0]:version::STRING  AS fraud_model_version,
  
    -- Name–Phone correlation score
    TRY_PARSE_JSON(extra_details):namePhoneCorrelation:score::FLOAT     AS name_phone_score,
  
  
    --ARISTOTLE?
    -- TRY_PARSE_JSON(extra_details):documentVerification:detail::FLOAT  AS docv_decision_new,
    -- TRY_PARSE_JSON(extra_details):documentVerification:result::STRING  AS docv_score_new,
    -- TRY_PARSE_JSON(extra_details):faceMatch:detail::FLOAT  AS facematch_decision,
    -- TRY_PARSE_JSON(extra_details):faceMatch:result::STRING  AS facematch_score,
    -- TRY_PARSE_JSON(extra_details):liveness:detail::FLOAT  AS liveness_decision,
    -- TRY_PARSE_JSON(extra_details):liveness:result::STRING  AS liveness_score,
  
    -- OPTIONAL scores – check if these exist in your data
    TRY_PARSE_JSON(extra_details):phoneRisk:score::FLOAT                AS phone_score,
    TRY_PARSE_JSON(extra_details):emailRisk:score::FLOAT                AS email_score,
  
    
    row_number() over (partition by account_id order by created desc) rn
  FROM 
      fbg_source.osb_source.kyc_check_results x
  WHERE 
      TRY_PARSE_JSON(extra_details) IS NOT NULL
      and created::date >= '2025-01-01'
      --and account_id = 4243298
  )
  
  select * exclude rn
  from details
  where rn = 1
  
  ),
  
  total_ftus AS (
  
  
  WITH ftu AS (
  
  select 
      acco_id
      , CONVERT_TIMEZONE('UTC', 'America/New_York', placed_time) AS placed_time_est
      , id as bet_id
      , row_number() over(partition by acco_id order by placed_time) rn
  from 
      fbg_source.osb_source.bets
  qualify rn = 1
  
  ),
  
  first_bets AS (
  
  select 
      f.acco_id
      --, min(sport) as first_sport
      , LISTAGG(DISTINCT sport, ', ') WITHIN GROUP (ORDER BY sport) as first_sports
  from 
      ftu f inner join fbg_source.osb_source.bet_parts bp on f.bet_id = bp.bet_id
  group by all
  ),
  
  customer_mart AS (
  
  select 
      acco_id
      , registration_date_est
      , registration_geolocation_state as geo_state
      , state as kyc_state
      , kyc_date_est
      , acquisition_bonus_name
      , acquisition_sub_channel
      , acquisition_promotion_code_on_registration
  FROM fbg_analytics_engineering.customers.customer_mart
  
  ),
  
  bank_info AS (
  
  select 
      acco_id
      , LISTAGG(DISTINCT GET(PARSE_JSON(GET(PARSE_JSON(p.info_json), 'paymentProvider')), 'name')::string, ', ') 
          WITHIN GROUP (ORDER BY GET(PARSE_JSON(GET(PARSE_JSON(p.info_json), 'paymentProvider')), 'name')::string) as banks
  from 
      fbg_source.osb_source.payment_options p
  where 
      type = 'TRUSTLY'
  group by all
  
  ),
  
  financials AS (
  
  select 
      TO_NUMBER(acco_id) as acco_id
      , SUM(case when trans = 'WITHDRAWAL_COMPLETED' then abs(amount) else 0 end) as withdrawal_amount
      , SUM(case when trans = 'DEPOSIT' then abs(amount) else 0 end) as deposit_amount
  from 
      fbg_source.osb_source.account_statements
  where
      trans IN ('WITHDRAWAL_COMPLETED', 'DEPOSIT')
  group by all
  
  ),
  
  devices AS 
  
  (
  SELECT DISTINCT 
      u.USER_ID as acco_id
      , e.DEVICE_TYPE
  FROM 
      FBG_SOURCE.AMPLITUDE.EVENT AS e
  INNER JOIN 
      FBG_GOVERNANCE.GOVERNANCE.AMPLITUDE_USERS AS u 
      ON u.AMPLITUDE_ID = e.AMPLITUDE_ID
  WHERE 
      1=1
      AND TO_DATE(e.EVENT_TIME) >= '2025-01-01'
      and event_type = 'account_creation_started'
  )
  
  
  
  select 
      f.* exclude rn
      , fb.* exclude acco_id
      , cm.* exclude acco_id
      , bi.* exclude acco_id
      , fi.* exclude acco_id
      , d.* exclude acco_id
  from ftu f join first_bets fb on f.acco_id = fb.acco_id
  left join customer_mart cm on f.acco_id = cm.acco_id
  left join bank_info bi on f.acco_id = bi.acco_id
  left join financials fi on f.acco_id = fi.acco_id
  left join devices d on f.acco_id = d.acco_id
  where
      1=1
      and registration_date_est::date >= '2025-01-01'
  
  )
  
  select *
  from total_details td left join total_ftus tf on td.account_id = tf.acco_id
  where first_sports is not null
  order by 1 desc
) "Custom SQL Query"
