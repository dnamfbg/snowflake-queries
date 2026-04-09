-- Query ID: 01c39a43-0112-6544-0000-e307218ccf72
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:27:47.811000+00:00
-- Elapsed: 16000ms
-- Environment: FES

select *
FROM loyalty.loyalty_core.loyalty_transaction_raw
--where order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141' and txn_status = 'AUTH';
where loyalty_txn_id = '3ace31b0-02d4-11f1-9856-4b7c7c1d8b89'
;
