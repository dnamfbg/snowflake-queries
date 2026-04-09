-- Query ID: 01c399c6-0212-6dbe-24dd-07031927b86b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:46.092000+00:00
-- Elapsed: 142ms
-- Environment: FBG

select catalog, schema, name, comment from "FMX_ANALYTICS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FMX_ANALYTICS' and schema = 'DIMENSIONS'   order by name limit 10000;
