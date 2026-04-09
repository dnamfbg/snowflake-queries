-- Query ID: 01c399e0-0212-67a9-24dd-0703192d25e7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:48:59.691000+00:00
-- Elapsed: 822ms
-- Environment: FBG

SELECT * FROM TABLE(RESULT_SCAN('01c399e0-0212-644a-24dd-0703192cdf3f')) WHERE 1=1
 AND $2 IN (:value_list_col_2_index_0)
