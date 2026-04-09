-- Query ID: 01c39a22-0212-67a8-24dd-0703193ca10f
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:54:20.645000+00:00
-- Elapsed: 779ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a21-0212-644a-24dd-0703193c84bb')) ORDER BY $7 ASC
) SELECT * FROM snowsight_transform_cte;
