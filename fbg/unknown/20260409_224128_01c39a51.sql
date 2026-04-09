-- Query ID: 01c39a51-0212-6dbe-24dd-0703194720c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:41:28.609000+00:00
-- Elapsed: 141ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUM_126 "$ Filled Contract Amount", LAG_127 "$ Filled Contract Amount period before" from (select DATETRUNC_124, SUM_125 SUM_126, lag(SUM_125, 1) over ( order by DATETRUNC_124 asc) LAG_127 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, sum(FILLED_CONTRACT_AMOUNT_USD) SUM_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=_qTsvE7Fbv","kind":"adhoc","request-id":"g019d746856ee72548ddb29cd29ee14c1","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
