-- Query ID: 01c39a37-0112-6544-0000-e307218ccbb6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:15:59.480000+00:00
-- Elapsed: 251ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'ALEX_SOTIS'   order by name limit 10000;
