-- Query ID: 01c399e2-0212-6e7d-24dd-0703192d4d63
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_SER_M_WH_PROD
-- Executed: 2026-04-09T20:50:27.048000+00:00
-- Elapsed: 760ms
-- Environment: FBG

WITH snowsight_transform_cte as (
    SELECT * FROM TABLE(RESULT_SCAN('01c399e2-0212-6cb9-24dd-0703192da037')) WHERE TO_VARCHAR($1) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($2) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($3) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($4) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($5) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($6) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($7) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($8) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($9) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($10) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($11) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($12) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($13) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($14) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($15) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($16) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($17) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($18) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($19) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($20) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($21) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($22) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($23) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($24) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($25) ILIKE :snowsight_transform_search_term ESCAPE '^' OR TO_VARCHAR($26) ILIKE :snowsight_transform_search_term ESCAPE '^'
) SELECT * FROM snowsight_transform_cte;
