-- Query ID: 01c39a1b-0212-644a-24dd-0703193afcdf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:47:34.940000+00:00
-- Elapsed: 188ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUB_127 "Actives", COUNTDISTINCT_128 "FTUs" from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, count(distinct iff(ORDER_STATUS = 'COMPLETED', ACCOUNT_ID, null)) - count(distinct iff(ORDER_STATUS = 'COMPLETED' and IS_FIRST_COMPLETED_TRADE, ACCOUNT_ID, null)) SUB_127, count(distinct iff(ORDER_STATUS = 'COMPLETED' and IS_FIRST_COMPLETED_TRADE, ACCOUNT_ID, null)) COUNTDISTINCT_128 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2025-12-03 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by DATETRUNC_124) Q1 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=QFTnUFg7MV","kind":"adhoc","request-id":"g019d7436ff24742f92c9d2643a3fff7c","user-id":"XfnJC4IXnEAdUPksdXltJAdCpOxa7","email":"louis.sutton@betfanatics.com"}
