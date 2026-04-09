-- Query ID: 01c39a5a-0112-6029-0000-e307218d2d9e
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Last Executed: 2026-04-09T22:50:27.974000+00:00
-- Elapsed: 116ms
-- Run Count: 2
-- Environment: FES

SELECT a.private_fan_id,a.first_install_ts_alk, a.fbg_ftu_ts_alk,a.had_fbg_pre_install,b.fanapp_ftu_attribution,b.ftu_day FROM FES_USERS.SANDBOX.FANAPP_COHORT_LABELS a 
LEFT JOIN FANAPP.REPORTING.FBG_AFFILIATE_FTUS b on a.private_fan_id = b.private_fan_id
WHERE a.private_fan_id = '3c779a10-898e-4c46-8b49-bb402fd359c0';
