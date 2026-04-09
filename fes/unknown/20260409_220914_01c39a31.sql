-- Query ID: 01c39a31-0112-6029-0000-e307218cb98a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T22:09:14.533000+00:00
-- Elapsed: 11463ms
-- Environment: FES

with earns AS (
    select 
        loyalty_account_id, loyalty_txn_id, 
        txn_status, txn_amount, fancash_balance, 
        loyalty_txn_reason, redeem_id, tenant_id, creation_time, 
        order_id, hashed_email, earn_tenant_id, earn_order_id
    from loyalty.loyalty_core.loyalty_analytics_ledger 
    where 
        creation_time >= DATEADD(DAY, -60, CURRENT_DATE) 
        AND loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
        AND STARTSWITH(txn_status, 'ADD')
        AND tenant_id = '100001'
    order by creation_time 
),

cancels AS (
    select 
        loyalty_account_id, loyalty_txn_id, 
        txn_status, txn_amount, fancash_balance, 
        loyalty_txn_reason, redeem_id, tenant_id, creation_time, 
        order_id, hashed_email, earn_tenant_id, earn_order_id
    from loyalty.loyalty_core.loyalty_analytics_ledger 
    where 
        creation_time >= DATEADD(DAY, -60, CURRENT_DATE) 
        AND loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
        AND STARTSWITH(txn_status, 'VOID')
        AND loyalty_txn_reason = 'reclaimed_fancash'
        AND tenant_id = '100001'
    order by creation_time 
)

select 
    a.loyalty_account_id, a.earn_txn_id, a.redeem_txn_id, a.txn_amount, 
    a.order_id, a.creation_time, a.tenant_id, a.earn_tenant_id, a.earn_order_id, 
    CASE WHEN b.loyalty_txn_id IS NOT NULL THEN TRUE ELSE FALSE END AS is_cancelled, 
    b.creation_time as cancel_time
from loyalty.loyalty_core.loyalty_earn_burn_mapper as a
left join cancels as b 
on a.earn_order_id = b.order_id
where 
    a.creation_time >= DATEADD(DAY, -60, CURRENT_DATE) 
    AND a.loyalty_account_id = '7fbaa992-9873-11e7-af10-7981552c1562'
order by a.creation_time
