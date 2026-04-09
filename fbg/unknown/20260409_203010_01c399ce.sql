-- Query ID: 01c399ce-0212-6b00-24dd-07031929273f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:30:10.386000+00:00
-- Elapsed: 527ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399cd-0212-6b00-24dd-0703192924fb')) ORDER BY $1 ASC
) SELECT * FROM snowsight_transform_cte;
