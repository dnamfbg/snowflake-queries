-- Query ID: 01c39a24-0212-6cb9-24dd-0703193ce62f
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:56:07.916000+00:00
-- Elapsed: 762ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a21-0212-644a-24dd-0703193c84bb')) ORDER BY $5 DESC
) SELECT * FROM snowsight_transform_cte;
