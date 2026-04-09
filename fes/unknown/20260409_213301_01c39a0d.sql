-- Query ID: 01c39a0d-0112-6029-0000-e307218b84da
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:33:01.201000+00:00
-- Elapsed: 575ms
-- Environment: FES

SELECT * FROM TABLE(RESULT_SCAN('01c39a0b-0112-6f44-0000-e307218b1f3e')) WHERE 1=1
 AND $19 IN (:value_list_col_19_index_0)
