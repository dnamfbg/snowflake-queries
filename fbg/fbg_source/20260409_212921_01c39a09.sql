-- Query ID: 01c39a09-0212-6dbe-24dd-070319369453
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: SNOWFLAKE_LEARNING_WH
-- Executed: 2026-04-09T21:29:21.870000+00:00
-- Elapsed: 13740ms
-- Environment: FBG

SELECT
    id,
    email,
    username,
    status
FROM "FBG_SOURCE"."OSB_SOURCE"."ACCOUNTS"
WHERE email = 'adam.vilmin@betfanatics.com';
