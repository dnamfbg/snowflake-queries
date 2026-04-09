-- Query ID: 01c39a1a-0212-6b00-24dd-0703193aca9f
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:46:50.617000+00:00
-- Elapsed: 553ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a1a-0212-67a8-24dd-0703193b200b')) ORDER BY $2 DESC
) SELECT * FROM snowsight_transform_cte;
