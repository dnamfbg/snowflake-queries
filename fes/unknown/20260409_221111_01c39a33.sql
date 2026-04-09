-- Query ID: 01c39a33-0112-6029-0000-e307218cbd76
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:11:11.653000+00:00
-- Elapsed: 1362ms
-- Environment: FES

select *
FROM loyalty.loyalty_core.loyalty_transaction_raw
where order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141' and txn_status = 'AUTH';
