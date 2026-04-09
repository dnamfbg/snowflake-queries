-- Query ID: 01c39a65-0212-6e7d-24dd-0703194b12bb
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T23:01:12.747000+00:00
-- Elapsed: 26248ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."# of Withdrawals" AS "# of Withdrawals",
  "Custom SQL Query"."Completed Day" AS "Completed Day",
  "Custom SQL Query"."Total Withdrawal Amount" AS "Total Withdrawal Amount",
  "Custom SQL Query"."Withdrawal PMT Method" AS "Withdrawal PMT Method"
FROM (
  select 
  to_date(DATE_TRUNC('Day',CONVERT_TIMEZONE('UTC','America/New_York',w.completed_at))) as "Completed Day"
  -- , a.vip
  --,ac.user_segment
  -- , w.account_id
   --, ac.reg_state
  , w.payment_brand as "Withdrawal PMT Method"
  --,w.gateway
   --, z.payment_brand as "Deposit PMT Method"
   --,COALESCE(c.jurisdiction_code, d.jurisdiction_code) as state
  --, COUNT(DISTINCT w.account_id) as "Unique Users"
   , COUNT(DISTINCT w.ID) as "# of Withdrawals"
   --, AVG(w.amount) as "Avg Withdrawal Amount"
   ,SUM(w.amount) as "Total Withdrawal Amount"
   from fbg_source.osb_source.withdrawals w
  left join fbg_source.osb_source.accounts a on w.account_id = a.id
  --LEFT JOIN deposits z on z.acco_id=a.id 
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart ac on ac.acco_id=a.id
  
  left join fbg_source.osb_source.jurisdictions as c
  on a.current_jurisdictions_id = c.id
  
  left join fbg_source.osb_source.jurisdictions as d
  on a.reg_jurisdictions_id = d.id
      --where a.vip = 0
  where w.completed_at >= '2023-01-01'
   and a.test = 0
  and w.status = 'WITHDRAWAL_COMPLETED'
  --and z.status = 'DEPOSIT_SUCCESS'
     --and completed_at >= NOW() - INTERVAL 1 DAY
  
      --and w.payment_brand <> 'TERMINAL'
      --and z.payment_brand <> 'TERMINAL'
      
      --and state in ('PA')
      GROUP BY ALL
      order by "Completed Day" DESC
) "Custom SQL Query"
