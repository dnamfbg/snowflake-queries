-- Query ID: 01c399ea-0212-6cb9-24dd-0703192ee717
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:58:32.342000+00:00
-- Elapsed: 381ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399ea-0212-644a-24dd-0703192f4257')) ORDER BY $3 ASC
) SELECT * FROM snowsight_transform_cte;
