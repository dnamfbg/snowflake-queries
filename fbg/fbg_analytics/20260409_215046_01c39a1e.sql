-- Query ID: 01c39a1e-0212-6dbe-24dd-0703193baa97
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: SNOWFLAKE_LEARNING_WH
-- Executed: 2026-04-09T21:50:46.239000+00:00
-- Elapsed: 1947ms
-- Environment: FBG

select * from fbg_source.fmx_source.exchange_markets where source_id = 'NX.F.OPT.BOX-00001-260411-M.O.1.2'
