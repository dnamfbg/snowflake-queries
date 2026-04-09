-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e4867
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:01:46.752000+00:00
-- Elapsed: 2079ms
-- Environment: FBG

SELECT "Custom SQL Query"."CASES_ESCALATED_W" AS "CASES_ESCALATED_W",
  "Custom SQL Query"."SUBTYPEBUCKET_W" AS "SUBTYPEBUCKET_W",
  "Custom SQL Query"."SUBTYPE_W" AS "SUBTYPE_W",
  "Custom SQL Query"."WEEK_SF_E" AS "WEEK_SF_E"
FROM (
  with test as(
  SELECT *
  ,left(b.createddate,4) yearr,
  substr(b.createddate,6,2) monthh,
  substr(b.createddate,9,2) dayy,
  substr(b.createddate,12,2) clockhour,
  substr(b.createddate,15,2) clockmin,
  substr(b.createddate,18,2) clocksec,
  case 
  when sub_type__c in ('Outbound Document Request') then 'Outbound'
  when sub_type__c in ('Device Sharing','Payment Method Sharing','Proxy Play','GeoComply Device Sharing Block') then 'Sharing'
  when sub_type__c in ('Fraud Suspension','Suspected ATO') then 'Suspected Fraud'
  when sub_type__c in ('Payment Fraud','Identity Theft') then 'True Fraud'
  else 'Other'
  end as "actual_subtype"
  FROM fbg_source.salesforce.o_case b
  LEFT JOIN fbg_source.SALESFORCE.O_user a ON b.ownerid = a.id
  WHERE 
  b.createddate!= 'None' 
  ),
  
  final as(
  SELECT DISTINCT sub_type__c as subtype_w,
  --SELECT DISTINCT 
  "actual_subtype" as subtypebucket_w,
  count (DISTINCT casenumber) AS cases_escalated_w,
  date_trunc('day',CONVERT_TIMEZONE('UTC','America/New_York',to_timestamp(concat(yearr,'-',monthh,'-',dayy,' ',clockhour,':',clockmin,':',clocksec),'YYYY-MM-DD HH:MI:SS'))) as day
  FROM test
  where 
  --date(day) = :daterange
  --AND 
  (origin != 'Manual' AND ownerid = '00G8V000005MqjIUAS')
  AND type in ('Fraud') and status <> 'Merged' and sub_type__c not in ('Cancelled','Cancelled by User','Cancelled by Agent')
  and date(day) < '2025-03-28'
  GROUP BY ALL 
  ORDER BY day DESC, cases_escalated_w DESC),
  
  final2 as(
  SELECT DISTINCT sub_type__c as subtype_w,
  --SELECT DISTINCT 
  "actual_subtype" as subtypebucket_w,
  count (DISTINCT casenumber) AS cases_escalated_w,
  date_trunc('day',CONVERT_TIMEZONE('UTC','America/New_York',to_timestamp(concat(yearr,'-',monthh,'-',dayy,' ',clockhour,':',clockmin,':',clocksec),'YYYY-MM-DD HH:MI:SS'))) as day
  FROM test
  where date(day) > '2025-03-27'
  AND (origin != 'Manual' and name in ('Alana Mann','Angie Carsolio','Billy Layne','Bowen Smith','David Zembrzuski','Elijah Beck','Gorgi Markoski','Joe DiFonzo','Joel Wagner','Joshua Jackson','Kevin Namendorf','Kristian Ruhe','Lesley Polanco','Marlon Reid','Stephanie Brown','Talha Bhatti','Nelson Guzman'))
  AND type in ('Fraud') and status <> 'Merged' and sub_type__c not in ('Cancelled','Cancelled by User','Cancelled by Agent')
  GROUP BY ALL 
  ORDER BY day DESC, cases_escalated_w DESC)
  
  select to_date(day) as week_sf_e, subtype_w, subtypebucket_w, cases_escalated_w
  from final
  union all
  select to_date(day) as week_sf_e, subtype_w, subtypebucket_w, cases_escalated_w
  from final2 
  order by week_sf_e asc
) "Custom SQL Query"
