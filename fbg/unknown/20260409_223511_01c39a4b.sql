-- Query ID: 01c39a4b-0212-6dbe-24dd-0703194586b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:35:11.998000+00:00
-- Elapsed: 615ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a4b-0212-67a8-24dd-070319454afb')) ORDER BY $1 DESC
) SELECT * FROM snowsight_transform_cte;
