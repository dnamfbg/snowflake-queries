-- Query ID: 01c39a24-0112-6be5-0000-e307218bb9a2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:56:26.907000+00:00
-- Elapsed: 2188ms
-- Environment: FES

select 
    loyalty_account_id, loyalty_txn_id, 
    txn_status, txn_amount, fancash_balance, 
    loyalty_txn_reason, redeem_id, tenant_id, creation_time, 
    order_id, hashed_email, earn_tenant_id, earn_order_id
from loyalty.loyalty_core.loyalty_analytics_ledger 
where 
    creation_time >= DATEADD(DAY, -60, CURRENT_DATE) 
    AND loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
