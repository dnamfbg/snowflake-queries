-- Query ID: 01c39a54-0112-6544-0000-e307218d56b6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:44:19.243000+00:00
-- Elapsed: 736ms
-- Environment: FES

select *
FROM loyalty.loyalty_core.loyalty_transaction_raw
where loyalty_txn_id = '3ace31b0-02d4-11f1-9856-4b7c7c1d8b89'
and txn_status = 'AUTH'
;
