-- Query ID: 01c399f4-0212-6cb9-24dd-07031931d3b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:08:51.126000+00:00
-- Elapsed: 4450ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399f4-0212-6dbe-24dd-070319318bdb')) ORDER BY $3 DESC
) SELECT * FROM snowsight_transform_cte;
