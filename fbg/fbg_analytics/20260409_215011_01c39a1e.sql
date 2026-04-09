-- Query ID: 01c39a1e-0212-6cb9-24dd-0703193b6fcf
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:50:11.633000+00:00
-- Elapsed: 3370ms
-- Environment: FBG

SELECT
*
FROM
fbg_source.osb_source.account_bonuses
where
bonus_campaign_id in (1101361)
;
