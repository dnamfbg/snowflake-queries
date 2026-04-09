-- Query ID: 01c39a2d-0112-6ccc-0000-e307218c530e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:05:54.167000+00:00
-- Elapsed: 7620ms
-- Environment: FES

select *
from loyalty.loyalty_core.loyalty_redeem
WHERE loyalty_txn_id = '3acafd60-02d4-11f1-bd95-8def29e5c141';
