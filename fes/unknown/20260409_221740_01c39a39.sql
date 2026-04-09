-- Query ID: 01c39a39-0112-6544-0000-e307218ccc76
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:17:40.690000+00:00
-- Elapsed: 814ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'SANDBOX'   order by name limit 10000;
