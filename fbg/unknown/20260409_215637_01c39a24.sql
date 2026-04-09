-- Query ID: 01c39a24-0212-67a8-24dd-0703193d203f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:56:37.218000+00:00
-- Elapsed: 504ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a23-0212-6e7d-24dd-0703193cc46f')) ORDER BY $5 DESC
) SELECT * FROM snowsight_transform_cte;
