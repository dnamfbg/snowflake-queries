-- Query ID: 01c39a31-0112-6029-0000-e307218cba8e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:09:26.043000+00:00
-- Elapsed: 16937ms
-- Environment: FES

select *
FROM loyalty.loyalty_core.loyalty_transaction_raw
where order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141';
