-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4e93
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:02:25.982000+00:00
-- Elapsed: 2933ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query"."AGENT" AS "AGENT",
  "Custom SQL Query"."CLOSEDCASES" AS "CLOSEDCASES",
  "Custom SQL Query"."COMPANY_NAME" AS "COMPANY_NAME",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."EMAIL" AS "EMAIL",
  "Custom SQL Query"."HRSWORKED" AS "HRSWORKED"
FROM (
  with step1 as (
  select
  convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusenddate,'T',1),left(SPLIT_PART(statusenddate,'T',2),12))))) as statusenddate, 
  date_trunc('day',convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusenddate,'T',1),left(SPLIT_PART(statusenddate,'T',2),12)))))) as endhour, 
  convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusstartdate,'T',1),left(SPLIT_PART(statusstartdate,'T',2),12))))) as statusstartdate, 
  date_trunc('day',convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusstartdate,'T',1),left(SPLIT_PART(statusstartdate,'T',2),12)))))) as starthour, 
  ownerid,
  servicepresencestatus_developername,
  statusduration,
  datediff(second, date_trunc('day',convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusenddate,'T',1),left(SPLIT_PART(statusenddate,'T',2),12)))))),convert_timezone('UTC', 'America/New_York', (try_to_timestamp(concat_ws(' ',SPLIT_PART(statusenddate,'T',1),left(SPLIT_PART(statusenddate,'T',2),12)))))) as dailyduration,
  from FBG_SOURCE.SALESFORCE.O_USERSERVICEPRESENCE where statusenddate <> 'None' and endhour is not null ),
  
  staging as (select 
  date(hour) as ddate,
  agent,
  closedcases,
  HrsWorked,
  email,
  ClosedCases/NULLIF(HrsWorked, 0) as CPH,
  company_name as companyname
  FROM(
  select 
  endhour,
  b.name,
  b.email,
  SUM(
  CASE
      WHEN endhour = starthour AND 
      (SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='AvailableEmailandChatOnly' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Available_Chat_Only'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Available_Email_Only'  
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='AvailableAllChannels'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Follow_Up' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Payments' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='AvailableEmailandChatOnly' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Chat_Only' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Chat_only' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Email_Only'  
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='AvailableAllChannels'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Follow_Up' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Payments')
      THEN STATUSDURATION/3600
      WHEN endhour != starthour AND 
      (SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='AvailableEmailandChatOnly' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Available_Chat_Only'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Available_Email_Only'  
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='AvailableAllChannels'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Follow_Up' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\', \'',2),'\'',1) ='Payments' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='AvailableEmailandChatOnly' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Chat_Only' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Chat_only' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Available_Email_Only'  
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='AvailableAllChannels'   
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Follow_Up' 
      OR SPLIT_PART(SPLIT_PART(servicepresencestatus_developername,'DeveloperName\': \'',2),'\'',1) ='Payments')
      then dailyduration/3600
      ELSE 0
    END) as HrsWorked 
  from step1
  LEFT JOIN fbg_source.salesforce.o_user b ON ownerid = b.id
  group by all) a
  LEFT JOIN (
  Select
  CASE
  WHEN PENDING_START_TIME__C IS null THEN 
  date_trunc('day',convert_timezone('UTC', 'America/New_York', try_to_timestamp(concat_ws(' ',SPLIT_PART(a.closeddate,'T',1),left(SPLIT_PART(a.closeddate,'T',2),12)))))
  WHEN PENDING_START_TIME__C ='None' THEN 
  date_trunc('day',convert_timezone('UTC', 'America/New_York', try_to_timestamp(concat_ws(' ',SPLIT_PART(a.closeddate,'T',1),left(SPLIT_PART(a.closeddate,'T',2),12)))))
  WHEN PENDING_START_TIME__C IS NOT null THEN 
  date_trunc('day',convert_timezone('UTC', 'America/New_York', try_to_timestamp(concat_ws(' ',SPLIT_PART(a.PENDING_START_TIME__C,'T',1),left(SPLIT_PART(a.PENDING_START_TIME__C,'T',2),12)))))
  ELSE ''
  END as Hour,
  b.name as Agent,
  count(DISTINCT a.casenumber) AS ClosedCases,
  b.companyname as company_name
  FROM fbg_source.SALESFORCE.O_CASE a 
  LEFT JOIN fbg_source.salesforce.o_user b ON a.ownerid = b.id
  where b.companyname! IN ('None', 'New Company Name') and a.type<>'Cancelled Chat' and a.status<>'Merged' and a.SUB_TYPE__C<>'Cancelled' and a.SUB_TYPE__C<>'Cancelled by User' and a.SUB_TYPE__C<>'Cancelled by Agent'
  --AND day = dateadd(day, -1, current_date)
  GROUP BY ALL
  order by hour desc, ClosedCases desc) b
  ON a.name=b.agent AND a.endhour=b.hour
  where agent<>'' 
  --and hour > '2024-08-31'
  and hrsworked >1
  GROUP BY ALL order by ddate desc ,agent asc)
  
  SELECT 
      ddate as day, 
      agent,
      email,
      closedcases, 
      hrsworked, 
      companyname as company_name
  FROM staging
) "Custom SQL Query"
