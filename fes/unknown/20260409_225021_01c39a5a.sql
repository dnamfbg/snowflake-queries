-- Query ID: 01c39a5a-0112-6f84-0000-e307218db2c6
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Last Executed: 2026-04-09T22:50:21.230000+00:00
-- Elapsed: 73ms
-- Run Count: 2
-- Environment: FES

SELECT amplitude_id,amplitude_id_final,event_type,event_time,user_id,user_id_corrected,user_id_merged FROM FDE.FDE_INFO.AMPLITUDE_EVENTS_CORRECTION WHERE user_id = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' or user_id_corrected = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' ORDER BY EVENT_TIME ASC
