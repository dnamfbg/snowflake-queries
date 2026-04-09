-- Query ID: 01c39a30-0112-6b51-0000-e307218c86aa
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:08:33.071000+00:00
-- Elapsed: 1659ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'ZOE_SARWAR'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
