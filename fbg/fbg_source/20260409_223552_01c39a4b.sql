-- Query ID: 01c39a4b-0212-67a9-24dd-070319455f23
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_M_PROD
-- Last Executed: 2026-04-09T22:35:52.543000+00:00
-- Elapsed: 392129ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BALANCE" AS "BALANCE"
FROM (
  select acco_id, balance
  from (
  select row_number() over (partition by acco_id order by trans_date desc) as row_num , acs.acco_id, acs.balance
  from fbg_source.osb_source.account_statements acs
  left join fbg_source.osb_source.accounts a 
  	on acs.acco_id = a.id
  where  acs.fund_type_id = 1
  and coalesce(client_id, 'FBG_PAYMENTS') in ('FBG_NATS', 'FBG_PAYMENTS')
  )
  where row_num = 1
  and balance < 0
  order by balance asc
) "Custom SQL Query"
