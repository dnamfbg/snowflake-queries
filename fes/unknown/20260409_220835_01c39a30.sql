-- Query ID: 01c39a30-0112-6bf9-0000-e307218c6caa
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:08:35.097000+00:00
-- Elapsed: 311ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'ZOE_SARWAR'   order by name limit 10000;
