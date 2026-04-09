-- Query ID: 01c399f7-0212-6e7d-24dd-07031932943b
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:11:16.149000+00:00
-- Elapsed: 6872ms
-- Environment: FBG

WITH awards AS (

    SELECT
        ats_account_id AS acco_id,
        bonus_campaign AS bc,
        DATE(created_date) AS dt
    FROM FBG_SOURCE.FANX_MONGODB.FANCASH
    WHERE bonus_campaign IN ('1027079','1028359')
)

SELECT
    DATE_TRUNC('WEEK', dt) AS week_start_monday,
    COUNT(DISTINCT acco_id) AS used_accounts
FROM awards
GROUP BY 1
ORDER BY 1;
