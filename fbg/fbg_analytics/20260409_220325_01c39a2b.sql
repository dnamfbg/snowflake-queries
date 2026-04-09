-- Query ID: 01c39a2b-0212-6cb9-24dd-0703193ec34b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:03:25.353000+00:00
-- Elapsed: 97990ms
-- Environment: FBG

SELECT "Custom SQL Query"."AGENT_EMAIL" AS "AGENT_EMAIL",
  "Custom SQL Query"."AVG_WAIT_MIN" AS "AVG_WAIT_MIN",
  "Custom SQL Query"."CASE_NUMBER" AS "CASE_NUMBER",
  "Custom SQL Query"."CASE_SUBTYPE" AS "CASE_SUBTYPE",
  "Custom SQL Query"."CASE_TYPE" AS "CASE_TYPE",
  "Custom SQL Query"."PRODUCT_FLAG" AS "PRODUCT_FLAG",
  "Custom SQL Query"."REQUEST_DAY" AS "REQUEST_DAY"
FROM (
  with messaging_session_details as (
  select
    m.id as messaging_session_id
    ,m.caseid
    ,m.agenttype
    ,case when m.accepttime = 'None' then NULL 
          else TO_TIMESTAMP(m.accepttime, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM') end AS case_accepted_time_utc
    ,case when m.agent_requested_time__c = 'None' then NULL 
          else TO_TIMESTAMP(m.agent_requested_time__c, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM') end AS agent_request_time_utc
    ,CONVERT_TIMEZONE('UTC','America/New_York',case_accepted_time_utc) as case_accepted_time
    ,CONVERT_TIMEZONE('UTC','America/New_York',agent_request_time_utc) as agent_request_time
    
          
  from fbg_source.salesforce.o_messagingsession m
  where 1=1
    and m.accepttime is not null
    and agent_requested_time__c is not null
    and m.accepttime >= '2024-09-01'
    and caseid <> 'None'
  )
  
  ,stg as (
  select
    m.messaging_session_id
    ,date(agent_request_time) as request_day
    ,datediff('seconds',m.agent_request_time,m.case_accepted_time) as Wait_Secs
    ,case_number
    ,case_type
    ,case_subtype
    ,agent_email
    ,product_flag
    
  from messaging_session_details m
  left join fbg_analytics.operations.cs_cases c on c.case_id = m.caseid
  where 
    1=1
    and agent_request_time >= '2024-09-01' 
    and agent_request_time <> current_date() 
    and case_source = 'Inbound: Chat - Agent'
    and agenttype <> 'Bot'
  group by all
  order by Wait_Secs desc
  )
  
  select 
    request_day
    ,case_number
    ,case_type
    ,case_subtype
    ,agent_email
    ,(Wait_Secs)/60 as Avg_Wait_Min
    ,product_flag
  from stg
  group by all
  order by 1 DESC
) "Custom SQL Query"
