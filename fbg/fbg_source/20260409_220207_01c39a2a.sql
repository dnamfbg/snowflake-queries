-- Query ID: 01c39a2a-0212-67a9-24dd-0703193e57db
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:07.378000+00:00
-- Elapsed: 3145ms
-- Environment: FBG

SELECT "Custom SQL Query"."APPLEPAY" AS "APPLEPAY",
  "Custom SQL Query"."CARD" AS "CARD",
  CAST("Custom SQL Query"."DAY" AS DATE) AS "DAY",
  "Custom SQL Query"."PAYPAL" AS "PAYPAL",
  "Custom SQL Query"."TRUSTLY" AS "TRUSTLY",
  "Custom SQL Query"."VENMO" AS "VENMO"
FROM (
  with paypal as(
  select DATE_TRUNC('day', created) as day, avg(amount) as paypal
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' and payment_brand = 'PAYPAL' 
  group by all order by day desc
  ),
  
  trustly as(
  select DATE_TRUNC('day', created) as day, avg(amount) as trustly
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' and payment_brand = 'TRUSTLY' 
  group by all order by day desc
  ),
  
  card as(
  select DATE_TRUNC('day', created) as day, avg(amount) as card
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' and payment_brand = 'CARD' 
  group by all order by day desc
  ),
  
  venmo as(
  select DATE_TRUNC('day', created) as day, avg(amount) as venmo
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' and payment_brand = 'VENMO' 
  group by all order by day desc
  ),
  
  applepay as(
  select DATE_TRUNC('day', created) as day, avg(amount) as applepay
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' and payment_brand = 'APPLEPAY' 
  group by all order by day desc
  )
  
  select a.day as day, applepay, card, trustly, paypal, venmo
  from applepay a
  left join paypal p on a.day = p.day
  left join card c on a.day = c.day
  left join trustly t on a.day = t.day
  left join venmo v on a.day = v.day
  where a.day > DATEADD(DAY,-15,current_date)
  and a.day <> current_date
  GROUP BY all ORDER by a.day desc
) "Custom SQL Query"
