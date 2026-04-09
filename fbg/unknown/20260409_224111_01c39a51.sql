-- Query ID: 01c39a51-0212-67a9-24dd-07031946bef3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:41:11.100000+00:00
-- Elapsed: 161ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", COUNTDISTINCT_125 "# Filled Trades", LAG_126 "# Filled Trades period before" from (select DATETRUNC_124, COUNTDISTINCT_125, lag(COUNTDISTINCT_125, 1) over ( order by DATETRUNC_124 asc) LAG_126 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, count(distinct iff(ORDER_STATUS = 'COMPLETED', ORDER_ID, null)) COUNTDISTINCT_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-04-06 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=5isoJXHMtV","kind":"adhoc","request-id":"g019d74680ff676249a313524c35c60cf","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
