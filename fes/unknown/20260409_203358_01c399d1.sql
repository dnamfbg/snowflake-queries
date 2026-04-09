-- Query ID: 01c399d1-0112-6029-0000-e3072189ad1a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:33:58.802000+00:00
-- Elapsed: 1235ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399ce-0112-6db7-0000-e307218a0086')) ORDER BY $1 DESC
) SELECT * FROM snowsight_transform_cte;
