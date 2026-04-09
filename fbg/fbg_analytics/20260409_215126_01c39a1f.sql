-- Query ID: 01c39a1f-0212-67a8-24dd-0703193bcf0f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: SNOWFLAKE_LEARNING_WH
-- Executed: 2026-04-09T21:51:26.044000+00:00
-- Elapsed: 2845ms
-- Environment: FBG

select ec.* from fbg_source.fmx_source.exchange_markets em join fbg_source.fmx_source.exchange_contests ec on em.contest_id = ec.id where em.source_id = 'NX.F.OPT.BOX-00001-260411-M.O.1.2'
