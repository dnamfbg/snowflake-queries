-- Query ID: 01c39a34-0112-6029-0000-e307218cbeae
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:30.271000+00:00
-- Elapsed: 1258ms
-- Environment: FES

select TABLE_NAME, TABLE_TYPE, CREATED, LAST_DDL, LAST_ALTERED, COMMENT from "FES_USERS"."INFORMATION_SCHEMA"."TABLES" where table_schema = 'RMCSPEDON'  and TABLE_NAME like '%'  order by TABLE_NAME limit 10001;
