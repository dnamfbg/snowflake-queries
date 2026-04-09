-- Query ID: 01c399c6-0212-6dbe-24dd-07031927b89b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:47.178000+00:00
-- Elapsed: 138ms
-- Environment: FBG

select catalog, schema, name, comment from "FMX_ANALYTICS"."INFORMATION_SCHEMA"."SEMANTIC_VIEWS" where catalog = 'FMX_ANALYTICS' and schema = 'MARKET_MAKER'   order by name limit 10000;
