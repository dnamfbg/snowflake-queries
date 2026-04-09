-- Query ID: 01c39a37-0112-6544-0000-e307218ccbae
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:15:58.270000+00:00
-- Elapsed: 840ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'ALEX_SOTIS'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
