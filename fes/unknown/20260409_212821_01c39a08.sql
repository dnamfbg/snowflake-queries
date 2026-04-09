-- Query ID: 01c39a08-0112-6f44-0000-e307218b1d6e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:28:21.197000+00:00
-- Elapsed: 166ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'SEAN_MCCLURE'   order by name limit 10000;
