-- Query ID: 01c39a29-0212-6e7d-24dd-0703193dff5f
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:08.139000+00:00
-- Elapsed: 46518ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACTIVES" AS "ACTIVES",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."FRAUDSUSPENSIONS" AS "FRAUDSUSPENSIONS"
FROM (
  with fraudsuspensions  as (
  select 
      DATE(b.modified) as day,
      case 
      when parse_json(data):message::varchar ilike '%FBG account Suspended during Pointsbet migration%' then 'Suspended from PB Migration'
      when parse_json(data):source::varchar = 'SocureWatchlist' then parse_json(data):message::varchar
      when parse_json(data):source::varchar = 'duplicateAccountCheck' then 'Duplicate Account Found'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Sift%' then 'Sift Rule'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%device sharing%' then 'Device Sharing'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%User Request (No RG)%' then 'User Request Closure'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Suspected ATO%' then 'Suspected ATO'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Confirmed Duplicate%' then 'Confirmed Duplicate'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Self_Excluded%' then 'Self Excluded'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%RG%' then 'RG Closure'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Fraud%' then 'Suspected Fraud'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Underage%' then 'Suspected Underage'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%Proxy%' then 'Proxy Play'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%payment method sharing%' then 'Payment Method Sharing'
      when SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) ilike '%chargebacks%' then 'Chargebacks'
      else SPLIT_PART(SPLIT_PART(data, 'Reason:', 2), ',', 1) 
      end AS reason,
      from fbg_source.osb_source.account_history b
      join FBG_SOURCE.OSB_SOURCE.accounts a
      on a.id = b.modified_acc_id
      where data ilike '%blockAccount%' 
      and a.test = 0
      order by day desc),
  
  actives as (select
  DATE(date(CONVERT_TIMEZONE('UTC','America/New_York',a.placed_time))) as day,
  count(distinct a.acco_id) as actives,
  count(distinct case when a.free_bet = 'FALSE' then a.acco_id else null END) as cash_actives
  
  from fbg_source.osb_source.bets as a
  
  where a.status in ('ACCEPTED','SETTLED')
  and a.test = 0
  and a.pointsbet_bet_id is null
  group by all
  ORDER BY 1 DESC)
  
  SELECT to_date(c.day) as day,
  count_if(reason in ('Suspected Fraud','Suspected ATO','Device Sharing','Sift Rule','Payment Method Sharing','Proxy Play','Chargebacks')) as fraudsuspensions,
  actives,
  --fraudsuspensions/ actives as "Suspensions/Active"
  FROM fraudsuspensions c 
  LEFT JOIN actives a on a.day=c.day
  where c.day > DATEADD(DAY,-15,current_date) and c.day <> current_date
  GROUP BY ALL
  
  ORDER BY DAY DESC
) "Custom SQL Query"
