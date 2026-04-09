-- Query ID: 01c39a08-0112-6ccc-0000-e307218b3cca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:28:18.969000+00:00
-- Elapsed: 309ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'LUKE_HARMON'   order by name limit 10000;
