-- Query ID: 01c39a34-0112-6806-0000-e307218c9eea
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:33.049000+00:00
-- Elapsed: 164ms
-- Environment: FES

select catalog, schema, name, comment from "FES_USERS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FES_USERS' and schema = 'HAJIME_ALABANZA'   order by name limit 10000;
