-- Query ID: 01c39a4e-0112-6f84-0000-e307218cae26
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:38:54.057000+00:00
-- Elapsed: 21432ms
-- Environment: FES

SELECT * 
FROM loyalty.loyalty_core.loyalty_state 
WHERE loyalty_account_id = '777df200-8326-11ea-ac58-515e6d9aa6c5'
and creation_time <= '2026-02-05'
--and ((txn_status_final = 'EARN_REDEEM' and txn_amount <> original_add) or txn_status_final = 'EARN')
order by creation_time;
