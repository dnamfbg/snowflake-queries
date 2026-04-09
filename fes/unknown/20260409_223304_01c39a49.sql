-- Query ID: 01c39a49-0112-6f82-0000-e307218d0ad2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:33:04.594000+00:00
-- Elapsed: 435400ms
-- Environment: FES

select * 
FROM fes_users.garland_pope.EXT_REDEEM_LEDGER_PROCESSED
where loyalty_txn_id = '3ace31b0-02d4-11f1-9856-4b7c7c1d8b89'
;
