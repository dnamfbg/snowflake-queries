-- Query ID: 01c39a51-0112-6bf9-0000-e307218da042
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:41:46.635000+00:00
-- Elapsed: 10365ms
-- Environment: FES

select *
FROM loyalty.loyalty_core.loyalty_transaction_raw
where loyalty_txn_id = '3f91b4c0-e81b-11f0-a6bc-71510b756cae'
