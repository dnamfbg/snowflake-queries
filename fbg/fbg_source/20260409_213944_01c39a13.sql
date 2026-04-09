-- Query ID: 01c39a13-0212-67a9-24dd-0703193966eb
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: SNOWFLAKE_LEARNING_WH
-- Last Executed: 2026-04-09T21:39:44.950000+00:00
-- Elapsed: 15046ms
-- Run Count: 2
-- Environment: FBG

SELECT
    id,
    email,
    status,
    username,
    registration_status,
    creation_date
FROM "FBG_SOURCE"."OSB_SOURCE"."ACCOUNTS"
WHERE email = 'adam.vilmin@betfanatics.com'
  AND deleted = 0;
