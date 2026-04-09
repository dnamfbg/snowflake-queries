-- Query ID: 01c39a57-0112-6f84-0000-e307218db22a
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T22:47:39.758000+00:00
-- Elapsed: 9996ms
-- Environment: FES

SELECT appsflyer_id,user_id_corrected,customer_user_id,event_time FROM fde.fde_info.appsflyer_inapps_correction WHERE customer_user_id = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' or  user_id_corrected = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' ORDER BY EVENT_TIME;
