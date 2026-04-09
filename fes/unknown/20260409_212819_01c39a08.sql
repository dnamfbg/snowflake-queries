-- Query ID: 01c39a08-0112-6ccc-0000-e307218b3cd6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:28:19.195000+00:00
-- Elapsed: 917ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'WILL_MACK'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
