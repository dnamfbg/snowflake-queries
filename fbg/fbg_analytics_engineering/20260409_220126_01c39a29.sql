-- Query ID: 01c39a29-0212-67a8-24dd-0703193e34e7
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:01:26.832000+00:00
-- Elapsed: 530158ms
-- Environment: FBG

SELECT "Custom SQL Query"."ALLCONTACTS" AS "ALLCONTACTS",
  "Custom SQL Query"."CONTACTRATE" AS "CONTACTRATE",
  "Custom SQL Query"."CONTACTS" AS "CONTACTS",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."ESCALATIONRATE" AS "ESCALATIONRATE",
  "Custom SQL Query"."FRAUDCAPTURERATE" AS "FRAUDCAPTURERATE",
  "Custom SQL Query"."SUSPENSIONS" AS "SUSPENSIONS",
  "Custom SQL Query"."TOTAL_ACTIVES" AS "TOTAL_ACTIVES"
FROM (
  ----- DAILY
  with casino_actives as (
  SELECT 
  DATE(date_trunc('day',CONVERT_TIMEZONE('America/Anchorage','America/New_York',session_end_time_alk))) as DATE,
  case when c.fund_type in ('CASH') then c.acco_id else null END as casino_cash_actives,
  c.acco_id as casino_actives
  FROM fbg_analytics_engineering.casino.casino_sessions_mart C
  INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
  ON A.ID = C.Acco_ID
  WHERE A.Test = 0
  AND session_end_time_alk is not null and date > '2023-08-31'
  --and date = :daterange
  GROUP BY ALL
  ORDER BY DATE DESC),
  
  
  sbactives as (
  select
  date(date_trunc('day',CONVERT_TIMEZONE('UTC','America/New_York',a.placed_time))) as day,
  case when a.free_bet = 'FALSE' then a.acco_id else null END as osb_cash_actives,
  a.acco_id as osb_actives
  from fbg_source.osb_source.bets as a
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart u on u.acco_id=a.acco_id
  where a.status in ('ACCEPTED','SETTLED')
  and a.test = 0 
  and day > '2023-08-31'
  group by all
  ORDER BY 1 DESC),
  
  
  duals as (select day, count(distinct osb_cash_actives) as dual_cash_actives
  from sbactives s
  inner join casino_actives c on s.day = c.date and osb_cash_actives = casino_cash_actives
  group by all),
  
  dualsids as 
  (select day, osb_actives as dual_actives
  from sbactives s
  inner join casino_actives c on s.day = c.date and osb_actives = casino_actives
  group by all),
  
  sbkonly as (
  select day, count(distinct osb_cash_actives) as sbk_only_cash_actives,
  from sbactives s
  left outer join casino_actives c on s.day = c.date and osb_cash_actives = casino_cash_actives where c.casino_cash_actives is null
  group by all),
  
  sbkonlyids as (
  select day, osb_actives as sbk_only_actives,
  from sbactives s
  left outer join casino_actives c on s.day = c.date and osb_actives = casino_actives where c.casino_actives is null
  group by all),
  
  casonly as (
  select date, count(distinct casino_cash_actives) as ca_only_cash_actives
  from casino_actives c 
  left outer join sbactives s on s.day = c.date and osb_cash_actives = casino_cash_actives where s.osb_cash_actives is null
  group by all), 
  
  casonlyids as (
  select date, casino_actives as ca_only_actives
  from casino_actives c 
  left outer join sbactives s on s.day = c.date and osb_actives = casino_actives where s.osb_actives is null
  group by all), 
  
  contactsetup as (
  select
  DATE_TRUNC('day',CONVERT_TIMEZONE('UTC','America/New_York',to_timestamp(concat(yearr,'-',monthh,'-',dayy,' ',clockhour,':',clockmin,':',clocksec),'YYYY-MM-DD HH:MI:SS'))) as day,
  date(day) as DDate,
  count(distinct customers) as contactingcx,
  count (distinct casenumber) as contacts
  
  from
  (
  SELECT *
  ,c.type as contact_type
  ,c.casenumber as case_number
  ,u.current_state as state
  ,u.is_pb_user as migration
  ,c.sub_type__c as subtype
  ,a.id as customers
  ,u.current_value_band as segment
  ,left(createddate,4) yearr,
  substr(createddate,6,2) monthh,
  substr(createddate,9,2) dayy,
  substr(createddate,12,2) clockhour,
  substr(createddate,15,2) clockmin,
  substr(createddate,18,2) clocksec,
  createddate
  FROM FBG_SOURCE.SALESFORCE.O_CASE c
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a on a.email=c.contactemail
  left join fbg_analytics_engineering.customers.customer_mart u on a.id = u.acco_id
  
  WHERE
  createddate!= 'None'
  AND contact_type = 'Fraud'
  AND (origin != 'Manual' AND ownerid = '00G8V000005MqjIUAS')
  and c.status <> 'Merged' and sub_type__c not in ('Cancelled','Cancelled by User','Cancelled by Agent'))
  
  where day < '2025-03-28'
  GROUP BY ALL
  ORDER BY day desc),
  
  contactsetup2 as (
  select
  DATE_TRUNC('day',CONVERT_TIMEZONE('UTC','America/New_York',to_timestamp(concat(yearr,'-',monthh,'-',dayy,' ',clockhour,':',clockmin,':',clocksec),'YYYY-MM-DD HH:MI:SS'))) as day,
  date(day) as DDate,
  count(distinct customers) as contactingcx,
  count (distinct casenumber) as contacts
  
  from
  (
  SELECT *
  ,c.type as contact_type
  ,c.casenumber as case_number
  ,u.current_state as state
  ,u.is_pb_user as migration
  ,c.sub_type__c as subtype
  ,a.id as customers
  ,u.current_value_band as segment
  ,left(c.createddate,4) yearr,
  substr(c.createddate,6,2) monthh,
  substr(c.createddate,9,2) dayy,
  substr(c.createddate,12,2) clockhour,
  substr(c.createddate,15,2) clockmin,
  substr(c.createddate,18,2) clocksec,
  c.createddate
  FROM FBG_SOURCE.SALESFORCE.O_CASE c
  left join fbg_source.salesforce.o_user o on c.ownerid = o.id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a on a.email=c.contactemail
  left join fbg_analytics_engineering.customers.customer_mart u on a.id = u.acco_id
  
  WHERE
  c.createddate!= 'None'
  AND contact_type = 'Fraud'
  AND (origin != 'Manual' AND o.name in ('Alana Mann','Angie Carsolio','Billy Layne','Bowen Smith','David Zembrzuski','Elijah Beck','Gorgi Markoski','Joe DiFonzo','Joel Wagner','Joshua Jackson','Kevin Namendorf','Kristian Ruhe','Lesley Polanco','Marlon Reid','Stephanie Brown','Talha Bhatti','Nelson Guzman'))
  and c.status <> 'Merged' and sub_type__c not in ('Cancelled','Cancelled by User','Cancelled by Agent'))
  
  where day > '2025-03-27'
  GROUP BY ALL
  ORDER BY day desc),
  
  unioncontact as (
  select * 
  from contactsetup
  union all
  select *
  from contactsetup2
  ),
  
  allcontacts as (
  select
  DATE_TRUNC('day',CONVERT_TIMEZONE('UTC','America/New_York',to_timestamp(concat(yearr,'-',monthh,'-',dayy,' ',clockhour,':',clockmin,':',clocksec),'YYYY-MM-DD HH:MI:SS'))) as day,
  date(day) as DDate,
  count(distinct customers) as allcontactingcx,
  count (distinct casenumber) as allcontacts
  
  from
  (
  SELECT *
  ,c.type as contact_type
  ,c.casenumber as case_number
  ,u.current_state as state
  ,u.is_pb_user as migration
  ,c.sub_type__c as subtype
  ,a.id as customers
  ,u.current_value_band as segment
  ,left(createddate,4) yearr,
  substr(createddate,6,2) monthh,
  substr(createddate,9,2) dayy,
  substr(createddate,12,2) clockhour,
  substr(createddate,15,2) clockmin,
  substr(createddate,18,2) clocksec,
  createddate
  FROM FBG_SOURCE.SALESFORCE.O_CASE c
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a on a.email=c.contactemail
  left join fbg_analytics_engineering.customers.customer_mart u on a.id = u.acco_id
  
  WHERE
  createddate!= 'None'
  AND contact_type = 'Fraud'
  AND (origin != 'Manual')
  and c.status <> 'Merged' and sub_type__c not in ('Cancelled','Cancelled by User','Cancelled by Agent'))
  
  --where day = :daterange
  GROUP BY ALL
  ORDER BY day desc),
  
  fraudsuspensions  as (
  select 
      b.modified as day,
      modified_acc_id,
      case 
      when parse_json(data):message::varchar ilike '%FBG account Suspended during Pointsbet migration%' then 'Suspended from PB Migration'
      when parse_json(data):source::varchar = 'SocureWatchlist' then parse_json(data):message::varchar
      when parse_json(data):source::varchar = 'duplicateAccountCheck' then 'Duplicate Account Found'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%device sharing%' then 'Device Sharing'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%User Request (No RG)%' then 'User Request Closure'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Suspected ATO%' then 'Suspected ATO'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Confirmed Duplicate%' then 'Confirmed Duplicate'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Self_Excluded%' then 'Self Excluded'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%RG%' then 'RG Closure'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Suspected Payments Fraud%' then 'Suspected Payments Fraud'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Underage%' then 'Suspected Underage'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Suspected Proxy Play%' then 'Suspected Proxy Play'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Payment Method Sharing%' then 'Payment Method Sharing'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%chargebacks%' then 'Chargebacks'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Suspected Fraud%' then 'Suspected Fraud'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Confirmed Fraud%' then 'Confirmed Fraud'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Confirmed CC Fraud%' then 'Confirmed CC Fraud'
       when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Confirmed Underage' then 'Confirmed Underage'
      else SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) 
      end AS reason,
      from fbg_source.osb_source.account_history b
      join FBG_SOURCE.OSB_SOURCE.accounts a
      on a.id = b.modified_acc_id
      where data ilike '%blockAccount%' 
      --and day > '2024-08-01'
      and a.test = 0
      order by day desc),
  
  
  fraudsetup as (
  select date_trunc('day',day) as date,
      count(distinct modified_acc_id) as suspensions
      from fraudsuspensions
      where reason in ('Confirmed Fraud','Confirmed CC Fraud','Confirmed Underage')
      group by all),
  
  
  finaloutput as (
  select d.day, 
  --d.dual_cash_actives,
  --s.sbk_only_cash_actives,
  --c.ca_only_cash_actives,
  d.dual_cash_actives + s.sbk_only_cash_actives + c.ca_only_cash_actives as total_actives,
  contacts, allcontacts,
  allcontacts/total_actives as contactrate,
  contacts/allcontacts as escalationrate,
  suspensions,
  suspensions/total_actives as fraudcapturerate
  from duals d 
  left join sbkonly s on d.day = s.day
  left join casonly c on d.day = c.date
  left join unioncontact dw on d.day = dw.ddate
  left join allcontacts ac on d.day = ac.ddate
  left join fraudsetup f on d.day = f.date
  group by all
  order by 1 desc)
  
  select * from finaloutput order by 1 DESC
) "Custom SQL Query"
