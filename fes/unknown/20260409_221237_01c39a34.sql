-- Query ID: 01c39a34-0112-6f84-0000-e307218ca25a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:37.008000+00:00
-- Elapsed: 1294ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'DYLAN_TUCH'   order by name limit 10000;
