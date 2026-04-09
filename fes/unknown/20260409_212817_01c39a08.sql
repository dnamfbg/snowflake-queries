-- Query ID: 01c39a08-0112-6806-0000-e307218b64e6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:28:17.889000+00:00
-- Elapsed: 919ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'LUKE_HARMON'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
