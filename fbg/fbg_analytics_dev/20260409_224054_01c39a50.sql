-- Query ID: 01c39a50-0212-6e7d-24dd-07031946f357
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:40:54.731000+00:00
-- Elapsed: 5256ms
-- Run Count: 3
-- Environment: FBG

INSERT INTO FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_deposit_alert_100k (

select  a.acco_id,
        d.pseudonym,
        acc.vip,
        host.name as vip_host,
        j.jurisdiction_code as state,
        a.id as deposit_id,
        a.amount as amount_deposited,
        a.payment_brand,
        a.description,
        convert_timezone('UTC','America/New_York', completed_at) as deposit_time
        
from FBG_SOURCE.OSB_SOURCE.DEPOSITS as a

LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS J
on a.Jurisdictions_Id = j.Id

LEFT JOIN FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_deposit_alert_historical_100k as b
on a.id = b.deposit_id

INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS as acc
on a.acco_id = acc.id

INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart as d
on a.acco_id = d.acco_id

LEFT JOIN vip_host as host
on a.acco_id = host.acco_id

WHERE acc.test = 0
and a.status = 'DEPOSIT_SUCCESS'
and a.payment_brand <> 'TERMINAL'
and a.amount >= 100000
and b.deposit_id is null
)
