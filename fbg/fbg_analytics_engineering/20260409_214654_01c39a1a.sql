-- Query ID: 01c39a1a-0212-644a-24dd-0703193af937
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:46:54.971000+00:00
-- Elapsed: 708ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a1a-0212-67a8-24dd-0703193b200b')) ORDER BY $1 ASC
) SELECT * FROM snowsight_transform_cte;
