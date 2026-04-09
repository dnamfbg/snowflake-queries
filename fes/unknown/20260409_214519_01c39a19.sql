-- Query ID: 01c39a19-0112-6ccc-0000-e307218bd57a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:45:19.164000+00:00
-- Elapsed: 1082ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a0b-0112-6f44-0000-e307218b1f3e')) ORDER BY $20 DESC
) SELECT * FROM snowsight_transform_cte;
