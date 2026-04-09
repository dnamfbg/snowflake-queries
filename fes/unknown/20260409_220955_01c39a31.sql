-- Query ID: 01c39a31-0112-6806-0000-e307218c9c4a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T22:09:55.379000+00:00
-- Elapsed: 595ms
-- Environment: FES

SELECT * FROM TABLE(RESULT_SCAN('01c39a31-0112-6029-0000-e307218cb98a')) WHERE 1=1
 AND $10 IN (:value_list_col_10_index_0)
