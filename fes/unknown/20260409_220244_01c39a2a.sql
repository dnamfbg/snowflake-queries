-- Query ID: 01c39a2a-0112-6be5-0000-e307218bbd2a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T22:02:44.166000+00:00
-- Elapsed: 12600ms
-- Environment: FES

select 
    loyalty_account_id, earn_txn_id, redeem_txn_id, txn_amount, 
    order_id, creation_time, tenant_id, earn_tenant_id, earn_order_id 
from loyalty.loyalty_core.loyalty_earn_burn_mapper 
where 
    creation_time >= DATEADD(DAY, -60, CURRENT_DATE) 
    AND loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
order by creation_time
