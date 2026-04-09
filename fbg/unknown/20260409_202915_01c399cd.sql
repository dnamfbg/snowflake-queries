-- Query ID: 01c399cd-0212-6e7d-24dd-07031928cebf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:29:15.487000+00:00
-- Elapsed: 226ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUM_126 "$ Filled Contract Amount", LAG_127 "$ Filled Contract Amount period before" from (select DATETRUNC_124, SUM_125 SUM_126, lag(SUM_125, 1) over ( order by DATETRUNC_124 asc) LAG_127 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, sum(FILLED_CONTRACT_AMOUNT_USD) SUM_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=_qTsvE7Fbv","kind":"adhoc","request-id":"g019d73ef4a2f7af39b443732cd3e16e8","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
