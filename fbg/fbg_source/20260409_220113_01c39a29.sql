-- Query ID: 01c39a29-0212-67a9-24dd-0703193e5153
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:01:13.923000+00:00
-- Elapsed: 33787ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."CUSTOMERSSUBMITTING" AS "CUSTOMERSSUBMITTING",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."DOCVREFERRALS" AS "DOCVREFERRALS",
  "Custom SQL Query"."DocV Referral Rate" AS "DocV Referral Rate",
  "Custom SQL Query"."FIRSTTIMEPASS" AS "FIRSTTIMEPASS",
  "Custom SQL Query"."KYC Errors Rate" AS "KYC Errors Rate",
  "Custom SQL Query"."KYCCHECK" AS "KYCCHECK",
  "Custom SQL Query"."Passive KYC Rate" AS "Passive KYC Rate",
  "Custom SQL Query"."REJECTED" AS "REJECTED",
  "Custom SQL Query"."RESUBMITFAILS" AS "RESUBMITFAILS",
  "Custom SQL Query"."Reject Rate" AS "Reject Rate",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."WATCHLIST" AS "WATCHLIST",
  "Custom SQL Query"."Watchlist Rate" AS "Watchlist Rate"
FROM (
  WITH KYC_DATE AS
  (select
   a.account_id as acco_id, b.email as email
  ,COALESCE(c.jurisdiction_code, d.jurisdiction_code) as state
  --,d.jurisdiction_code as state
  ,convert_timezone('UTC','America/New_York',max(created)) as kyc_date
  
  
  from fbg_source.osb_source.kyc_check_results as a
  
  inner join fbg_source.osb_source.accounts as b
  on a.account_id = b.id
  
  left join fbg_source.osb_source.jurisdictions as c
  on b.current_jurisdictions_id = c.id
  
  left join fbg_source.osb_source.jurisdictions as d
  on b.reg_jurisdictions_id = d.id
  
  left join fbg_analytics_engineering.customers.customer_mart ac on a.account_id = ac.acco_id
  
  where b.test = 0 
  --and ac.is_pb_user = 0 
  and ac.duplicate_excluded_list_flag != 1
  
  group by all),
  
  
  
  -- STEP 1 --
  first_step AS(
  select
  'first_step' as funnel
  ,CASE WHEN decision = 'VERIFIED' then 'Verified'
        WHEN decision = 'DEFER' then 'DocV'
        WHEN decision = 'RESUBMIT' then 'Resubmit'
        WHEN decision = 'REJECTED' then 'Rejected'
        WHEN decision = 'MANUAL_REVIEW' then 'Watchlist Review'
        WHEN decision = 'KYC_CHECK_FAILED' then 'KYC_CHECK_FAILED'
        ELSE 'error'
  END as formresult      
  --,(parse_json(extra_details):kyc:decision)::varchar as kyc_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):kyc:decision)::varchar as kyc_decision
  --,(parse_json(extra_details):phoneRisk:decision)::varchar as phone_risk_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):phoneRisk:decision)::varchar as phone_risk_decision
  --,(parse_json(extra_details):deviceRisk:decision)::varchar as device_risk_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):deviceRisk:decision)::varchar as device_risk_decision
  --,(parse_json(extra_details):globalWatchlist:decision)::varchar as watchlist_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):globalWatchlist:decision)::varchar as watchlist_decision
  --,(parse_json(extra_details):documentVerification:decision)::varchar as docv_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):documentVerification:decision)::varchar as docv_decision
  ,*
  ,row_number() OVER(PARTITION BY account_id ORDER BY created desc) as row_n
  from fbg_source.osb_source.kyc_check_results
  where step = 1
  qualify row_n = 1)
  
  ,second_step AS (
  
  select
    'second' as funnel
    ,CASE WHEN decision = 'VERIFIED' then 'Verified'
          WHEN decision = 'DEFER' then 'DocV'
          WHEN decision = 'RESUBMIT' then 'Resubmit'
          WHEN decision = 'REJECTED' then 'Rejected'
          WHEN decision = 'MANUAL_REVIEW' then 'Watchlist Review'
          WHEN decision = 'KYC_CHECK_FAILED' then 'Rejected'
          ELSE 'error'
    END as formresult    
    ,decision
    ,(parse_json(replace(extra_details, ' None', 'null')):kyc:decision)::varchar as kyc_decision
    ,(parse_json(replace(extra_details, ' None', 'null')):phoneRisk:decision)::varchar as phone_risk_decision
    ,(parse_json(replace(extra_details, ' None', 'null')):deviceRisk:decision)::varchar as device_risk_decision
    ,(parse_json(replace(extra_details, ' None', 'null')):globalWatchlist:decision)::varchar as watchlist_decision
    ,(parse_json(replace(extra_details, ' None', 'null')):documentVerification:decision)::varchar as docv_decision
    ,*
    ,row_number() OVER(PARTITION BY account_id ORDER BY created desc) as row_n
  from fbg_source.osb_source.kyc_check_results
  where 
      1=1
      and step = 2
  qualify row_n = 1),
  
  
  
  -- Step 3 --
  docv_result AS(
  select
  'doc_v' as funnel
  ,CASE WHEN decision = 'VERIFIED' then 'Verified'
        WHEN decision = 'RESUBMIT' then 'Resubmit'
        WHEN decision = 'REJECTED' then 'Rejected'
        WHEN decision = 'MANUAL_REVIEW' then 'Watchlist Review'
        ELSE 'error'
  END as docvresult    
  --,(parse_json(extra_details):kyc:decision)::varchar as kyc_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):kyc:decision)::varchar as kyc_decision
  --,(parse_json(extra_details):phoneRisk:decision)::varchar as phone_risk_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):phoneRisk:decision)::varchar as phone_risk_decision
  --,(parse_json(extra_details):deviceRisk:decision)::varchar as device_risk_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):deviceRisk:decision)::varchar as device_risk_decision
  --,(parse_json(extra_details):globalWatchlist:decision)::varchar as watchlist_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):globalWatchlist:decision)::varchar as watchlist_decision
  --,(parse_json(extra_details):documentVerification:decision)::varchar as docv_decision
  ,(parse_json(replace(extra_details, ' None', 'null')):documentVerification:decision)::varchar as docv_decision
  ,*
  ,row_number() OVER(PARTITION BY account_id ORDER BY created desc) as row_n
  from fbg_source.osb_source.kyc_check_results
  where step = 3
  --and (created > '2023-08-31 20:03:35.135' OR created < '2023-08-31 17:18:09.020')
  qualify row_n = 1
  ),
  
  
  
  -- Pull those manually passed by CS --
  cs_manual AS(
  select
  distinct a.id as acco_id
  from fbg_source.osb_source.accounts as a
  left join (select distinct account_id from fbg_source.osb_source.kyc_check_results where decision = 'VERIFIED') as b
  on a.id = b.account_id
  where a.status = 'ACTIVE'
  and a.test = 0
  and b.account_id is null
  ),
  
  
  
  kyc_final AS(
  -- pull it all together --
  select
   a.acco_id,
   a.email
  ,a.state
  ,a.kyc_date
  ,b.formresult as kycformresult
  ,b.kyc_decision as first_decision_kyc
  ,b.phone_risk_decision as first_decision_phone_risk
  ,b.device_risk_decision as first_decision_device_risk
  ,b.watchlist_decision as first_decision_watchlist
  ,b2.formresult as new_kycformresult
  ,b2.kyc_decision as second_decision_kyc
  ,c.docvresult as docv_result
  ,c.docv_decision
  ,CASE WHEN d.acco_id is not null THEN 1 ELSE 0 END AS cs_manual
  ,b.extra_details as first_extra_details
  ,c.extra_details as doc_v_extra_details
  ,CASE WHEN a.state IN ('TN', 'MA', 'KY', 'CT', 'VT', 'PA', 'NC', 'NJ') 
        THEN 'Stepped_Up_State' 
        ELSE 'Non_Stepped_State'
      END AS state_type
  
  from kyc_date as a
  
  left join first_step as b
  on a.acco_id = b.account_id
  
  left join second_step as b2
  on a.acco_id = b2.account_id
  
  left join docv_result as c
  on a.acco_id = c.account_id
  
  left join cs_manual as d
  on a.acco_id = d.acco_id)
  
  
  select 
  date_trunc('day', (to_date(kyc_date))) AS day,
  state,
  COUNT(DISTINCT acco_id) as CustomersSubmitting
  ,COUNT_IF((kycformresult='Verified' OR new_kycformresult = 'Verified')) as firsttimepass
  ,COUNT_IF ((kycformresult = 'DocV')) as DocVreferrals
  ,COUNT_IF((kycformresult = 'Resbumit')) as resubmitfails
  ,COUNT_IF((kycformresult = 'Rejected')) as rejected
  ,COUNT_IF((kycformresult = 'Watchlist Review')) as Watchlist
  ,COUNT_IF((kycformresult = 'KYC_CHECK_FAILED')) as KYCCHECK,
  Firsttimepass/customerssubmitting as "Passive KYC Rate",
  DocVreferrals/customerssubmitting as "DocV Referral Rate",
  rejected/customerssubmitting as "Reject Rate",
  Watchlist/ customerssubmitting as "Watchlist Rate",
  KYCCHECK/customerssubmitting as "KYC Errors Rate"
  from kyc_final
  --where kyc_date >= dateadd(day, -3, current_date)
  group by all
  order by day desc
) "Custom SQL Query"
