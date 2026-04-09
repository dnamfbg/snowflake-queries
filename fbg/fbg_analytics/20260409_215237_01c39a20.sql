-- Query ID: 01c39a20-0212-67a8-24dd-0703193c4607
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: SNOWFLAKE_LEARNING_WH
-- Executed: 2026-04-09T21:52:37.653000+00:00
-- Elapsed: 177ms
-- Environment: FBG

select * from fbg_source.fmx_source.sport_contest_attributes where sport = 'BOXING'
