-- Query ID: 01c39a2c-0212-67a9-24dd-0703193ed79b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:04:20.134000+00:00
-- Elapsed: 619ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a2c-0212-67a8-24dd-0703193ebb67')) ORDER BY $1 ASC
) SELECT * FROM snowsight_transform_cte;
