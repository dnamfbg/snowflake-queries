-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e1f7f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:01:33.395000+00:00
-- Elapsed: 101228ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASENUMBER" AS "CASENUMBER",
  "Custom SQL Query"."CONTACTEMAIL" AS "CONTACTEMAIL",
  "Custom SQL Query"."DOCV_RESULT" AS "DOCV_RESULT",
  "Custom SQL Query"."Fail Reason" AS "Fail Reason",
  "Custom SQL Query"."IDComply/SocureID" AS "IDComply/SocureID",
  "Custom SQL Query"."KYCDATE" AS "KYCDATE",
  "Custom SQL Query"."KYCFORMRESULT" AS "KYCFORMRESULT",
  "Custom SQL Query"."MV Action Required" AS "MV Action Required",
  "Custom SQL Query"."SFCREATEDDATE" AS "SFCREATEDDATE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."STATUS" AS "STATUS"
FROM (
  WITH KYC_DATE AS
  (select
   a.account_id as acco_id, b.email as email
  ,COALESCE(c.jurisdiction_code, d.jurisdiction_code) as state
  --,d.jurisdiction_code as state
  ,convert_timezone('UTC','America/New_York',min(created)) as kyc_date
  
  from fbg_source.osb_source.kyc_check_results as a
  
  inner join fbg_source.osb_source.accounts as b
  on a.account_id = b.id
  
  left join fbg_source.osb_source.jurisdictions as c
  on b.current_jurisdictions_id = c.id
  
  left join fbg_source.osb_source.jurisdictions as d
  on b.reg_jurisdictions_id = d.id
  
  left join fbg_analytics_engineering.customers.customer_mart ac on a.account_id = ac.acco_id
  
  -- where b.test = 0 and ac.duplicate_excluded_list_flag != 1
  
  
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
        WHEN decision = 'KYC_CHECK_FAILED' then 'Rejected'
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
  ,row_number() OVER(PARTITION BY account_id ORDER BY created asc) as row_n
  from fbg_source.osb_source.kyc_check_results
  where step = 1
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
   b.origin_code,
   a.email
  ,a.state
  ,a.kyc_date
  ,b.formresult as kycformresult
  ,b.kyc_decision as first_decision_kyc
  ,b.phone_risk_decision as first_decision_phone_risk
  ,b.device_risk_decision as first_decision_device_risk
  ,b.watchlist_decision as first_decision_watchlist
  ,c.docvresult as docv_result
  ,c.docv_decision,
  b.external_ref as SocureID
  ,CASE WHEN d.acco_id is not null THEN 1 ELSE 0 END AS cs_manual
  ,b.extra_details as first_extra_details
  ,c.extra_details as doc_v_extra_details
  
  
  from kyc_date as a
  
  left join first_step as b
  on a.acco_id = b.account_id
  
  left join docv_result as c
  on a.acco_id = c.account_id
  
  left join cs_manual as d
  on a.acco_id = d.acco_id),
  
  
  KYCnext as (
  SELECT 
  KYC_date,
  k.acco_id,
  k.state,
  kycformresult,
  docv_result,
  cs_manual,
  first_extra_details,
  socureID,
  k.email,
  origin_code
  from kyc_final k
  left join fbg_source.osb_source.accounts a on k.acco_id = a.id
  group by all),
  
  
  kycend as (
  SELECT
  KYC_date,
  acco_id,
  state,
  kycformresult,
  docv_result,
  cs_manual,
  email,
  first_extra_details,
  ORIGIN_CODE,
  CASE WHEN ORIGIN_CODE = 'IDCOMPLY' then try_parse_json(first_EXTRA_DETAILS):alerts  end as LAAlerts,
  CASE WHEN ORIGIN_CODE = 'IDCOMPLY' then try_parse_json(first_EXTRA_DETAILS):details  end as LADetails,
  CASE WHEN first_extra_details ilike '%I909%' THEN 'I909 ' ELSE ' ' END as I909,
  CASE WHEN first_extra_details ilike '%I920%' THEN 'I920 ' ELSE ' ' END as I920,
  CASE WHEN first_extra_details ilike '%R922%' THEN 'R922 ' ELSE ' ' END as R922,
  CASE WHEN first_extra_details ilike '%R933%' THEN 'R933 ' ELSE ' ' END as R933,
  CASE WHEN first_extra_details ilike '%R978%' THEN 'R978 ' ELSE ' ' END as R978,
  CASE WHEN first_extra_details ilike '%R980%' THEN 'R980 ' ELSE ' ' END as R980,
  CASE WHEN first_extra_details ilike '%R919%' THEN 'R919 ' ELSE ' ' END as R919,
  CASE WHEN first_extra_details ilike '%R944%' THEN 'R944 ' ELSE ' ' END as R944,
  CASE WHEN first_extra_details ilike '%R576%'  THEN 'D005 ' ELSE ' ' END as D005,
  CASE WHEN first_extra_details ilike '%R561%' THEN 'D007 ' ELSE '  ' END as D007,
  CASE WHEN first_extra_details ilike '%R566%'  THEN 'D006 ' ELSE ' ' END as D006,
  CASE WHEN first_extra_details ilike '%I1903%' THEN 'I1903 ' ELSE ' ' END as I1903,
  CASE WHEN first_extra_details ilike '%I1904%' THEN 'I1904 ' ELSE ' ' END as I1904,
  CASE WHEN first_extra_details ilike '%I1906%' THEN 'I1906 ' ELSE ' ' END as I1906,
  CASE WHEN first_extra_details ilike '%I417%' THEN 'I417 ' ELSE ' ' END as I417,
  CASE WHEN first_extra_details ilike '%R907%' THEN 'R907 ' ELSE ' ' END as R907,
  CASE WHEN first_extra_details ilike '%R909%' THEN 'R909 ' ELSE ' ' END as R909,
  CASE WHEN first_extra_details ilike '%R932%' THEN 'R932 ' ELSE ' ' END as R932,
  CASE WHEN first_extra_details ilike '%R940%' THEN 'R940 ' ELSE ' ' END as R940,
  CASE WHEN first_extra_details ilike '%R953%' THEN 'R953 ' ELSE ' ' END as R953,
  CASE WHEN first_extra_details ilike '%R901%' THEN 'R901 ' ELSE ' ' END as R901,
  CASE WHEN first_extra_details ilike '%R902%' THEN 'R902 ' ELSE ' ' END as R902,
  CASE WHEN first_extra_details ilike '%R911%' THEN 'R911 ' ELSE ' ' END as R911,
  CASE WHEN first_extra_details ilike '%R913%' THEN 'R913 ' ELSE ' ' END as R913,
  CASE WHEN first_extra_details ilike '%R972%' THEN 'R972 ' ELSE ' ' END as R972,
  CASE WHEN first_extra_details ilike '%R973%' THEN 'R973 ' ELSE ' ' END as R973,
  CASE WHEN first_extra_details ilike '%R947%' THEN 'R947 ' ELSE ' ' END as R947,
  CASE WHEN first_extra_details ilike '%R916%' THEN 'R916 ' ELSE ' ' END as R916,
  CASE WHEN first_extra_details ilike '%R964%' THEN 'D002 ' ELSE ' ' END as D002,
  CASE WHEN first_extra_details not ilike '%R183%' and first_extra_details not ilike '%R185%'  and first_extra_details not ilike '%R184%' and first_extra_details ilike '%R186%' then 'D003' else ' ' END as D003,
  CASE WHEN first_extra_details ilike '%R182%' THEN 'R182' ELSE ' ' END as R182,
  CASE WHEN first_extra_details ilike '%R181%' THEN 'R181' ELSE ' ' END as R181,
  CASE WHEN first_extra_details ilike '%R180%' THEN 'R180' ELSE ' ' END as R180,
  
  socureId
  from KYCnext),
  
  
  disposition as (
  SELECT 
  kyc_date,
  k.acco_id,
  k.email,
  kycformresult,
  docv_result,
  socureid,
  k.state,
  LAAlerts,
  LADetails,
  case 
  when kycformresult != 'Verified' then concat(I909,I920,R933,R978,R980, R919, D005, D007,D006, R944) end as "DocV Fail Reason" ,
  case 
  when kycformresult != 'Verified' then concat(I1903,I1904,I1906,I417,R907,R909,R932,R940,R953) end as "Rejected Fail Reasons" ,
  case 
  when kycformresult != 'Verified' then concat(R901,R902,R911,R913,R972,R973,R947,R916,D002,R922) end as "Resubmit Fail Reasons" ,
  case 
  when kycformresult != 'Verified' then concat(D003,R182,R181,R180) end as "Watchlist Fail Reasons" ,
  case when kycformresult != 'Verified' and Origin_code = 'IDCOMPLY' then 'LAFAIL' end as "LA Fail"
  from kycend k
  left join fbg_analytics_engineering.customers.customer_mart ac on k.acco_id = ac.acco_id
  left join fbg_source.osb_source.accounts a on k.acco_id = a.id
  where kyc_date >= '2024-01-01 13:00:00.00'),
  
  nextstep as (
  select kyc_date,
  acco_id,
  state,
  email,
  kycformresult,
  docv_result,
  socureid,
  LAAlerts,
  LADetails,
  "DocV Fail Reason",
  "Rejected Fail Reasons",
  "Resubmit Fail Reasons",
  "Watchlist Fail Reasons",
  "LA Fail",
  concat_ws('',ifnull("DocV Fail Reason",' '),ifnull("Rejected Fail Reasons",' '),ifnull("Resubmit Fail Reasons",' '),ifnull("Watchlist Fail Reasons",' '),ifnull("LA Fail",' ')) "Fail Reason" from disposition),
  
  
  docsrequired as (
  select kyc_date,
  acco_id,
  state,
  email,
  kycformresult,
  docv_result,
  socureid,
  "DocV Fail Reason",
  "Rejected Fail Reasons",
  "Resubmit Fail Reasons",
  "Watchlist Fail Reasons",
  "Fail Reason",
  
  Case when "Fail Reason" ilike '%LAFAIL%' and (LAAlerts ilike '%mortal%' or LAAlerts ilike '%dob%' or LAAlerts ilike '%ip.fraud%' or LAAlerts ilike '%ip.invalid%' or LADetails ilike '%name%' or LADetails ilike '%dob%' or LADetails ilike '%phone%' or LADetails ilike '%email%') then 'ID + Headshot Upload through SDU - ' end as "SDU",
  
  Case when "Fail Reason" ilike '%LAFAIL%' and (LAAlerts ilike '%SSN.multi.names%' or LAAlerts ilike '%ssn.not.available%'  or LAAlerts ilike '%ssn.prior.dob%' or LADetails ilike '%ssn%') then 'SSN/Lexis Lookup - ' end as "SSN",
  
  Case when "Fail Reason" ilike '%LAFAIL%' and (LAAlerts ilike '%mortality%') then 'Deceased Flag In Lexis - ' end as "Deceased",
  
  
  Case when "Fail Reason" ilike '%LAFAIL%' and (LAAlerts ilike '%address.warning%' or LAAlerts ilike '%state.not.available%' or LAAlerts ilike '%zip.not.available%' or LAAlerts ilike '%street.not.available%'or LAAlerts ilike '%building.not.available%'or LAAlerts ilike'%city.not.available%' or LAAlerts ilike '%address.is.po%' or LADetails ilike '%street%' or LADetails ilike '%city%' or LADetails ilike '%state%' or LADetails ilike '%zip%') then ' POA - ' end as "LA POA",
  
  Case when "Fail Reason" ilike '%LAFAIL%' then ' Check IDComply For Watchlist - ' end as "LA Watchlist",
  
  Case 
  WHEN "Fail Reason" ilike '%I1903%' or "Fail Reason" ilike '%R916%' or "Fail Reason" ilike '%R919%' and state not in ('LA') or state in ('PA') then 'POA - ' end as "POA",
  
  CASE WHEN "Fail Reason" ilike '%I1904%' or "Fail Reason" ilike '%R909%' or "Fail Reason" ilike '%R940%' or "Fail Reason" ilike '%R953%' or "Fail Reason" ilike '%R901%' or "Fail Reason" ilike '%R911%' or "Fail Reason" ilike '%R913%' or "Fail Reason" ilike '%R947%' and state not in ('LA') or state in ('PA') then 'Lexis/SSN - ' end as "LexisNexis + Proof of SSN",
  
  CASE WHEN "Fail Reason" ilike '%R932%' or "Fail Reason" ilike '%R972%' or "Fail Reason" ilike '%R973%' or "Fail Reason" ilike '%D002%' and state not in ('LA') then 
  'POA-Google Non-Commercial Address - ' end as "Google & POA for Non-Commercial Address",
  
  CASE WHEN "Fail Reason" ilike '%I1906%' or "Fail Reason" ilike '%I417%' or "Fail Reason" ilike '%R907%' or "Fail Reason" ilike '%R902%' or "Fail Reason" ilike '%I909%' or "Fail Reason" ilike '%I920%' or "Fail Reason" ilike '%R922%' or "Fail Reason" ilike '%R933%' or "Fail Reason" ilike '%R978%' or "Fail Reason" ilike '%R980%' or "Fail Reason" ilike '%R944%' or "Fail Reason" ilike '%D005%' or "Fail Reason" ilike '%D006%' or "Fail Reason" ilike '%D006%' or (kycformresult = 'DocV' and "Fail Reason" not ilike '%R919%') and state not in ('LA') or state in ('TN','MA','KY','CT','VT','PA','NC','NJ') then  'DocV - ' end as "DocV Required",
  
  CASE WHEN "Fail Reason" ilike '%D003%' or "Fail Reason" ilike '%R182%' or "Fail Reason" ilike '%R181%' or "Fail Reason" ilike '%R180%'  and state not in ('LA') then 'Compare PII to Watchlist - ' end as "Compare Watchlist Hit to PII"
  
  from nextstep),
  
  final as (
  select kyc_date,acco_id, email,state, kycformresult, docv_result, socureid ,"Fail Reason", concat_ws('',ifnull("SDU",' '), ifnull("SSN",' '), ifnull("LA POA",'  '), ifnull("Deceased",' '), ifnull("LA Watchlist",' '), ifnull("DocV Required",' '),ifnull("LexisNexis + Proof of SSN",' '),ifnull("Google & POA for Non-Commercial Address",' '),ifnull("POA",' '),ifnull("Compare Watchlist Hit to PII",'')) as "MV Action Required" from docsrequired),
  
  sfcases as (
  SELECT a.ACCO_ID , b.contactemail ,to_date(kyc_date) as kycdate, b.casenumber,DATE(TO_TIMESTAMP_NTZ(b.createddate, 'YYYY-MM-DD"T"HH24:MI:SS.FF4TZHTZM')) as sfcreateddate,  a.state, b.status,a.kycformresult, a.docv_result, a.socureid as "IDComply/SocureID", "Fail Reason", "MV Action Required"
  from final a
  left join FBG_SOURCE.SALESFORCE.O_CASE b on a.email = b.contactemail
  left join fbg_analytics_engineering.customers.customer_mart ac on a.acco_id = ac. acco_id 
  where type = 'KYC')
  
  select * from sfcases order by sfcreateddate desc
) "Custom SQL Query"
