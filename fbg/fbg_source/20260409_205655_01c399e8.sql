-- Query ID: 01c399e8-0212-6cb9-24dd-0703192ee07b
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:56:55.257000+00:00
-- Elapsed: 1509ms
-- Environment: FBG

SELECT 
    table_name,
    row_count,
    ROUND(bytes / 1024 / 1024 / 1024, 2) AS size_gb
FROM information_schema.tables
WHERE table_name = 'promotions';
