-- Query ID: 01c39a57-0112-6544-0000-e307218d580e
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T22:47:21.605000+00:00
-- Elapsed: 17231ms
-- Environment: FES

SELECT * FROM fde.fde_info.appsflyer_inapps_correction WHERE customer_user_id = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' or  user_id_corrected = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' ORDER BY EVENT_TIME;
