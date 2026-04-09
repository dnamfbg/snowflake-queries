-- Query ID: 01c399c8-0212-6b00-24dd-07031927e937
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:24:35.958000+00:00
-- Elapsed: 1040ms
-- Environment: FBG

SELECT * FROM TABLE(RESULT_SCAN('01c399c4-0212-6e7d-24dd-07031926f887')) WHERE 1=1
 AND $3 IN (:value_list_col_3_index_0)
