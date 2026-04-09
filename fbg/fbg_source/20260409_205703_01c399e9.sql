-- Query ID: 01c399e9-0212-6cb9-24dd-0703192ee0eb
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:57:03.978000+00:00
-- Elapsed: 1761ms
-- Environment: FBG

SELECT 
    table_name,
    row_count,
    ROUND(bytes / 1024 / 1024 / 1024, 2) AS size_gb
FROM information_schema.tables
limit 10;
