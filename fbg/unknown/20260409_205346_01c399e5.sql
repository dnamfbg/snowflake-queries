-- Query ID: 01c399e5-0212-6e7d-24dd-0703192dedcb
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_L_WH
-- Executed: 2026-04-09T20:53:46.552000+00:00
-- Elapsed: 2701ms
-- Environment: FBG

select *
from fbg_unity_catalog.fmx_kafka_source.orderbook_raw
order by timestamp asc limit 100;
