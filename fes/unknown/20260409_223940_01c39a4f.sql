-- Query ID: 01c39a4f-0112-6806-0000-e307218d3a42
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:39:40.594000+00:00
-- Elapsed: 698ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a4e-0112-6f84-0000-e307218cae26')) ORDER BY $3 ASC
) SELECT * FROM snowsight_transform_cte;
