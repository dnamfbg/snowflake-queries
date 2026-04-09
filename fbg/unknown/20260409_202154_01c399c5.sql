-- Query ID: 01c399c5-0212-644a-24dd-070319279a8b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:21:54.003000+00:00
-- Elapsed: 621ms
-- Environment: FBG

select DATETRUNC_125 "Time Period", SUM_127 "$ Filled Handle", LAG_128 "Handle Previous Period" from (select DATETRUNC_125, SUM_126 SUM_127, lag(SUM_126, 1) over ( order by DATETRUNC_125 asc) LAG_128 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_125, sum(FILLED_HANDLE_USD) SUM_126 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where IS_TEST_ACCOUNT and not IS_TEST_ACCOUNT and SPORT_VS_OTHER in ('SPORT', 'OTHER') and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_125) Q1) Q2 order by DATETRUNC_125 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=pWaW4ybb3v","kind":"adhoc","request-id":"g019d73e889c67b1d81dc9047667f276e","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
