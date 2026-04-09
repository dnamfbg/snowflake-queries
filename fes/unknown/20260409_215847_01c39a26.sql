-- Query ID: 01c39a26-0112-6b51-0000-e307218c015e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:58:47.832000+00:00
-- Elapsed: 807ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a26-0112-6be5-0000-e307218bba3a')) ORDER BY $9 ASC
) SELECT * FROM snowsight_transform_cte;
