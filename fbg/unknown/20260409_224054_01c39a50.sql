-- Query ID: 01c39a50-0212-6dbe-24dd-07031946ca97
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:40:54.064000+00:00
-- Elapsed: 413ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUM_125 "$ Filled Fees", LAG_127 "$ Filled Fees period before" from (select DATETRUNC_124, SUM_125, lag(SUM_126, 1) over ( order by DATETRUNC_124 asc) LAG_127 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, sum(FMX_FEES_CHARGED_AFTER_REFUNDS_AND_CLAWBACKS_USD) SUM_125, sum(FILLED_FMX_FEES_USD) SUM_126 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-04-07 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-07 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=wqiyv92OYx","kind":"adhoc","request-id":"g019d7467cfd67da1b44709e0ab7aa69c","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
