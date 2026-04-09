-- Query ID: 01c39a50-0212-6e7d-24dd-07031946f27b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:40:50.340000+00:00
-- Elapsed: 239ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUM_128 "$ Filled Volume", COUNTDISTINCT_127 "# Completed Trades", COUNTDISTINCT_126 "# Actives", COUNTDISTINCT_125 "# FTUs" from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, count(distinct iff(ORDER_STATUS = 'COMPLETED' and IS_FIRST_COMPLETED_TRADE, ACCOUNT_ID, null)) COUNTDISTINCT_125, count(distinct iff(ORDER_STATUS = 'COMPLETED', ACCOUNT_ID, null)) COUNTDISTINCT_126, count(distinct iff(ORDER_STATUS = 'COMPLETED', ORDER_ID, null)) COUNTDISTINCT_127, sum(FILLED_HANDLE_USD) SUM_128 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) group by DATETRUNC_124) Q1 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=rVrXgnAakj","kind":"adhoc","request-id":"g019d7467c170747cbc06cdda47aab62a","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
