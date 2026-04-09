-- Query ID: 01c39a1d-0212-67a9-24dd-0703193b955f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:49:55.773000+00:00
-- Elapsed: 393ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a1c-0212-6cb9-24dd-0703193b63a3')) ORDER BY $5 DESC
) SELECT * FROM snowsight_transform_cte;
