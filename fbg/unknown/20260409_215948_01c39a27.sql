-- Query ID: 01c39a27-0212-6cb9-24dd-0703193d9b2b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:59:48.203000+00:00
-- Elapsed: 1756ms
-- Environment: FBG

SELECT column_name FROM FBG_UNITY_CATALOG.INFORMATION_SCHEMA.COLUMNS WHERE table_schema = 'QUANTS' AND table_name = 'PRICE_ALIGNMENT_HISTORY' AND column_name LIKE '%PIN%' OR column_name LIKE '%PINN%' ORDER BY column_name
