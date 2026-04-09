-- Query ID: 01c39a2a-0212-644a-24dd-0703193e63d7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:02:14.334000+00:00
-- Elapsed: 622ms
-- Environment: FBG

SELECT "Custom SQL Query"."AVGDEPOSITSIZE" AS "AVGDEPOSITSIZE",
  CAST("Custom SQL Query"."DAY" AS DATE) AS "DAY",
  "Custom SQL Query"."TOTALAMOUNT" AS "TOTALAMOUNT"
FROM (
  select DATE_TRUNC('day', created) as day,
  avg(amount) as avgdepositsize, 
  sum(amount) as totalamount
  from fbg_source.osb_source.deposits
  where status = 'DEPOSIT_SUCCESS' 
  and payment_brand not in ('TERMINAL','WIRETRANSFER') 
  and day > DATEADD(DAY,-15,current_date)
  and day <> current_date
  group by all 
  order by day desc
) "Custom SQL Query"
