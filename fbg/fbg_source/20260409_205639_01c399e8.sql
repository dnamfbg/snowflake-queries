-- Query ID: 01c399e8-0212-6dbe-24dd-0703192ea4fb
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:56:39.766000+00:00
-- Elapsed: 1453ms
-- Environment: FBG

SELECT 
    table_name,
    row_count,
    ROUND(bytes / 1024 / 1024 / 1024, 2) AS size_gb
FROM information_schema.tables
WHERE table_name = 'fbg_source.osb_source.promotions';
