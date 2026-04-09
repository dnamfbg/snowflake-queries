-- Query ID: 01c39a51-0112-6bf9-0000-e307218da00a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:41:00.012000+00:00
-- Elapsed: 2667ms
-- Environment: FES

select count(*), sum(txn_amount), min(creation_time)
from loyalty.loyalty_core.loyalty_redeem
--WHERE order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141';--$10.59 in FC
where redeem_id = '3f91b4c0-e81b-11f0-a6bc-71510b756cae'
;
