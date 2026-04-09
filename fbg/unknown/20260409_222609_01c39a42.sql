-- Query ID: 01c39a42-0212-6e7d-24dd-07031943b417
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:26:09.977000+00:00
-- Elapsed: 1369ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a41-0212-67a9-24dd-070319431fc7')) ORDER BY $18 DESC
) SELECT * FROM snowsight_transform_cte;
