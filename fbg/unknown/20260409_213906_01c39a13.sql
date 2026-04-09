-- Query ID: 01c39a13-0212-6cb9-24dd-07031938fd5f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:39:06.419000+00:00
-- Elapsed: 14505ms
-- Environment: FBG

SELECT count(distinct fangraph_id) FROm fde_fbg_info.fde_fbg_info.fangraph_non_pii_v limit 10;
