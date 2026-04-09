-- Query ID: 01c39a38-0112-6f82-0000-e307218d0456
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:16:00.413000+00:00
-- Elapsed: 1502ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'BERNICE_RAMIREZ'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
