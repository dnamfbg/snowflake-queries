-- Query ID: 01c39a55-0112-6f82-0000-e307218d0f1a
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Last Executed: 2026-04-09T22:45:17.584000+00:00
-- Elapsed: 241ms
-- Run Count: 2
-- Environment: FES

SELECT a.private_fan_id,a.first_install_ts_alk, a.fbg_ftu_ts_alk,a.had_fbg_pre_install,b.fanapp_ftu_attribution,b.ftu_day FROM FES_USERS.SANDBOX.FANAPP_COHORT_LABELS a 
LEFT JOIN FANAPP.REPORTING.FBG_AFFILIATE_FTUS b on a.private_fan_id = b.private_fan_id
WHERE b.private_fan_id is not null and a.had_fbg_pre_install =1;
