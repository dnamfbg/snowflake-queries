-- Query ID: 01c39a39-0112-6029-0000-e307218d21ca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:17:39.367000+00:00
-- Elapsed: 1042ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'SANDBOX'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
