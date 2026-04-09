-- Query ID: 01c39a28-0212-6e7d-24dd-0703193dfa1f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:00:55.376000+00:00
-- Elapsed: 234534ms
-- Environment: FBG

SELECT "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."DOCVABANDONS" AS "DOCVABANDONS",
  "Custom SQL Query"."DOCVPASSES" AS "DOCVPASSES",
  "Custom SQL Query"."DOCVREFERRALS" AS "DOCVREFERRALS",
  "Custom SQL Query"."FIRSTTIMEDOCVS" AS "FIRSTTIMEDOCVS",
  "Custom SQL Query"."FIRSTTIMEPASS" AS "FIRSTTIMEPASS",
  "Custom SQL Query"."IN_FRAUD_COHORT" AS "IN_FRAUD_COHORT",
  "Custom SQL Query"."NUM_VERIFIED" AS "NUM_VERIFIED",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATE_TYPE" AS "STATE_TYPE",
  "Custom SQL Query"."TOTAL_ACCOUNTS" AS "TOTAL_ACCOUNTS"
FROM (
  WITH KYC_DATE AS(
  select
    a.account_id as acco_id
    ,b.email as email
    ,COALESCE(c.jurisdiction_code, d.jurisdiction_code) as state
    ,convert_timezone('UTC','America/New_York',max(created)) as kyc_date
   -- ,a.*
  
  from fbg_source.osb_source.kyc_check_results as a
  inner join fbg_source.osb_source.accounts as b on a.account_id = b.id
  left join fbg_source.osb_source.jurisdictions as c on b.current_jurisdictions_id = c.id
  left join fbg_source.osb_source.jurisdictions as d on b.reg_jurisdictions_id = d.id
  left join fbg_analytics_engineering.customers.customer_mart ac on a.account_id = ac.acco_id
  
  where 
    1=1
    and b.test = 0  
    and ac.duplicate_excluded_list_flag != 1
  group by all
  )
  
  ,first_step AS(
  select
    'first_step' as funnel
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
      and step = 1
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
  qualify row_n = 1)
  
  
  
  ,docv_result AS(
  select
    'doc_v' as funnel
    ,CASE WHEN decision = 'VERIFIED' then 'Verified'
          WHEN decision = 'RESUBMIT' then 'Resubmit'
          WHEN decision = 'REJECTED' then 'Rejected'
          WHEN decision = 'MANUAL_REVIEW' then 'Watchlist Review'
          ELSE 'error'
    END as docvresult    
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
      and step = 3
  qualify row_n = 1
  )
  
  
  ,cs_manual AS(
  select
    distinct a.id as acco_id
  from fbg_source.osb_source.accounts as a
  left join (
                select distinct account_id 
                from fbg_source.osb_source.kyc_check_results 
                where decision = 'VERIFIED') as b
            on a.id = b.account_id
  where a.status = 'ACTIVE'
  and a.test = 0
  and b.account_id is null
  ),
  
  
  kyc_final AS(
  select
    a.acco_id
    ,case when f.acco_id is not null then 1 else 0 end as In_Fraud_Cohort
    ,a.email
    ,a.state
    ,a.kyc_date
    ,b.formresult as kycformresult
    ,b.kyc_decision as first_decision_kyc
    ,b2.formresult as new_kycformresult
    ,b2.kyc_decision as second_decision_kyc
    ,b.phone_risk_decision as first_decision_phone_risk
    ,b.device_risk_decision as first_decision_device_risk
    ,b.watchlist_decision as first_decision_watchlist
    ,c.docvresult as docv_result
    ,c.docv_decision
    ,CASE WHEN d.acco_id is not null THEN 1 ELSE 0 END AS cs_manual
    ,CASE WHEN a.state IN ('TN', 'MA', 'KY', 'CT', 'VT', 'PA', 'NC', 'NJ') 
          THEN 'Stepped_Up_State' 
          ELSE 'Non_Stepped_State'
     END AS state_type
  ,b.extra_details as first_extra_details
  ,c.extra_details as doc_v_extra_details
  
  from kyc_date as a
  left join first_step as b on a.acco_id = b.account_id
  left join second_step as b2 on a.acco_id = b2.account_id
  left join docv_result as c on a.acco_id = c.account_id
  left join cs_manual as d on a.acco_id = d.acco_id
  left join FBG_ANALYTICS_DEV.MATT_MEEHAN.FRAUD_COHORT_FINAL_2025_06_16 f on a.acco_id = f.acco_id
  group by all
  ),
  
  final AS (
  
  
  
  SELECT 
    
    date_trunc('day', (to_date(kyc_date))) AS day
    ,In_Fraud_Cohort
    ,state
    ,state_type
    ,COUNT_IF(kycformresult = 'Verified' or docv_result = 'Verified' or cs_manual = 1 or new_kycformresult = 'Verified') AS num_verified
    ,count(DISTINCT acco_id) as total_accounts
    ,COUNT_IF ((kycformresult = 'DocV')) as DocVreferrals
    ,COUNT_IF((kycformresult='Verified' OR new_kycformresult = 'Verified')) as firsttimepass
    ,COUNT_IF ((kycformresult = 'DocV' and DocV_Result = 'Verified' )) as docvpasses
    ,COUNT_IF((kycformresult = 'DocV' and DocV_RESULT is null)) as DocVAbandons
    ,COUNT_IF((kycformresult='DocV')) as firsttimedocvs
  
  from kyc_final
  group by all
  order by day
  )
  
  select *
  from final
) "Custom SQL Query"
