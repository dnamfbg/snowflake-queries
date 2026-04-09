-- Query ID: 01c39a56-0112-6b51-0000-e307218d4d0a
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T22:46:27.681000+00:00
-- Elapsed: 12288ms
-- Environment: FES

SELECT * FROM fde.fde_info.appsflyer_inapps_correction WHERE customer_user_id = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' or  user_id_corrected = '672f22f3-e4ac-43eb-8be9-e0cf1b1537e2' ;
