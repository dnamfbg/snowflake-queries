-- Query ID: 01c39a1f-0112-6ccc-0000-e307218bd6fa
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:51:08.196000+00:00
-- Elapsed: 588ms
-- Environment: FES

SELECT * FROM TABLE(RESULT_SCAN('01c39a1d-0112-6ccc-0000-e307218bd64a')) WHERE 1=1
 AND $8 IN (:value_list_col_8_index_0)
