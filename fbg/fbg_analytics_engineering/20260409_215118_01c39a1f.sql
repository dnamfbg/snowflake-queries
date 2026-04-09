-- Query ID: 01c39a1f-0212-644a-24dd-0703193c0493
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:51:18.870000+00:00
-- Elapsed: 1282ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a1d-0212-67a9-24dd-0703193b9383')) ORDER BY $1 ASC
) SELECT * FROM snowsight_transform_cte;
