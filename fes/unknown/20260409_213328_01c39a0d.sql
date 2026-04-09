-- Query ID: 01c39a0d-0112-6029-0000-e307218b8526
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:33:28.085000+00:00
-- Elapsed: 624ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a0b-0112-6f44-0000-e307218b1f3e')) ORDER BY $19 DESC
) SELECT * FROM snowsight_transform_cte;
