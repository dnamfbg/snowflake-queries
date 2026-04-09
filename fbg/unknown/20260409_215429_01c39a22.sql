-- Query ID: 01c39a22-0212-6cb9-24dd-0703193c7a73
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:54:29.851000+00:00
-- Elapsed: 401ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a22-0212-644a-24dd-0703193c88c7')) WHERE TO_VARCHAR($1) ILIKE :snowsight_transform_search_term ESCAPE '^'
) SELECT * FROM snowsight_transform_cte;
