-- Query ID: 01c399da-0212-6dbe-24dd-0703192be623
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:21.392000+00:00
-- Elapsed: 68ms
-- Environment: FBG

select DATETRUNC_47 "Time Period", SUM_48 "Sum of Filled Handle Usd", LAG_49 "Period Before of Open Markets" from (select DATETRUNC_47, SUM_48, lag(SUM_48, 1) over ( order by DATETRUNC_47 asc) LAG_49 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_47, sum(FILLED_HANDLE_USD) SUM_48 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_47) Q1) Q2 order by DATETRUNC_47 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=xuoNUCYMGF","kind":"adhoc","request-id":"g019d73fb418c749fa13071ed1b018f61","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
