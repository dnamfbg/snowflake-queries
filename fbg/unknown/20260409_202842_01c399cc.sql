-- Query ID: 01c399cc-0212-6b00-24dd-070319288f0b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:28:42.297000+00:00
-- Elapsed: 95ms
-- Environment: FBG

select DATETRUNC_46 "Time Period", SUM_47 "Same Sport Filled Handle", SUM_48 "Multi Sport Filled Handle" from (select date_trunc(day, ORDER_CREATED_AT::timestamp_ltz) DATETRUNC_46, sum(iff(COMBO_TYPE = 'SAME_SPORT', FILLED_HANDLE_USD, null)) SUM_47, sum(iff(COMBO_TYPE = 'MULTI_SPORT', FILLED_HANDLE_USD, null)) SUM_48 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by DATETRUNC_46) Q1 order by DATETRUNC_46 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=1FRwXWdmZZ","kind":"adhoc","request-id":"g019d73eec68c7c2aa17bde4a56c278b8","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
