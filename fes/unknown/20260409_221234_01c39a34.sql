-- Query ID: 01c39a34-0112-6029-0000-e307218cbeea
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:34.155000+00:00
-- Elapsed: 289ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'GARLAND_POPE'   order by name limit 10000;
