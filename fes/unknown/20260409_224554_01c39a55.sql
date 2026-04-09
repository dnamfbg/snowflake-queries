-- Query ID: 01c39a55-0112-6544-0000-e307218d576e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Last Executed: 2026-04-09T22:45:54.099000+00:00
-- Elapsed: 85ms
-- Run Count: 2
-- Environment: FES

select count(*), sum(txn_amount), min(creation_time)
from loyalty.loyalty_core.loyalty_redeem
--WHERE order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141';--$10.59 in FC
where redeem_id = '3ace31b0-02d4-11f1-9856-4b7c7c1d8b89'
;
