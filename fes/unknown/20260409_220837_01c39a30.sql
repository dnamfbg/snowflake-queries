-- Query ID: 01c39a30-0112-6ccc-0000-e307218c5eca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:08:37.398000+00:00
-- Elapsed: 358ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'TYLER_KUNKEL'   order by name limit 10000;
