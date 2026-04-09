-- Query ID: 01c39a07-0212-6dbe-24dd-070319361bc7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:27:58.562000+00:00
-- Elapsed: 2781ms
-- Environment: FBG

SELECT
    a.ID,
    a.NAME,
    a.USERNAME,
    a.TYPE,
    a.TEST,
    a.VIP,
    a.VIP_GROUP,
    a.STATUS,
    a.COUNTRY_CODE,
    a.CREATION_DATE,
    a.BRAND_ID,
    a.PATH,
    a.ACCOUNT_PATH
FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS a
WHERE a.ID IN (6224940, 6155568, 853458, 1797877, 3060939, 6389928, 790793)
