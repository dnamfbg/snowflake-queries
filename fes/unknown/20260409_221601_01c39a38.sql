-- Query ID: 01c39a38-0112-6bf9-0000-e307218cf6ae
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:16:01.183000+00:00
-- Elapsed: 397ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'DBT_TESTING'   order by name limit 10000;
