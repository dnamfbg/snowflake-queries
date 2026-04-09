-- Query ID: 01c399d3-0212-6b00-24dd-0703192a596f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:35:51.209000+00:00
-- Elapsed: 483ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399d3-0212-6e7d-24dd-0703192a626b')) ORDER BY $3 ASC
) SELECT * FROM snowsight_transform_cte;
