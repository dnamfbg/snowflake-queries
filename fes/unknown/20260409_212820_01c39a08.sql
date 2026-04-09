-- Query ID: 01c39a08-0112-6029-0000-e307218b82ca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:28:20.233000+00:00
-- Elapsed: 129ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'WILL_MACK'   order by name limit 10000;
