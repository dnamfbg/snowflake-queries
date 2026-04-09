-- Query ID: 01c39a34-0112-6b51-0000-e307218c8e82
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:31.174000+00:00
-- Elapsed: 132ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'ANDREW_JARVIE'   order by name limit 10000;
