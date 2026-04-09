-- Query ID: 01c399c8-0212-67a8-24dd-07031927dba3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH_PROD
-- Executed: 2026-04-09T20:24:29.142000+00:00
-- Elapsed: 1148ms
-- Environment: FBG

SELECT *
FROM fbg_source_dev.osb_source.account_statements
WHERE bet_id IN (
    '26137856000019851',
    '26137856000019951',
    '26137855000019951',
    '26137837000019851',
    '26137832000019951',
    '26130848000019851',
    '26130856000019951',
    '26130853000019951',
    '26130849000019951',
    '26130840000019851'
);
