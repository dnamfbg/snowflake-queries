-- Query ID: 01c39a12-0212-67a8-24dd-07031938e547
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:38:01.094000+00:00
-- Elapsed: 785ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c39a11-0212-67a8-24dd-07031938e373')) WHERE TO_VARCHAR($1) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($2) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($3) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($4) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($5) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($6) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($7) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($8) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($9) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($10) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($11) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($12) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($13) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($14) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($15) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($16) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($17) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($18) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($19) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($20) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($21) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($22) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($23) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($24) ILIKE :snowsight_transform_search_term ESCAPE '^'
) SELECT * FROM snowsight_transform_cte;
