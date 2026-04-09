-- Query ID: 01c399c7-0212-6e7d-24dd-07031928212f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:51.961000+00:00
-- Elapsed: 120ms
-- Environment: FBG

select DATETRUNC_125 "Time Period Filter", DIV_130 "% Success Rate (Singles)", DIV_131 "% Success Rate (Combos)" from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_125, sum(iff(SPORT_VS_OTHER <> 'COMBOS', iff(TRADE_ACTION = 'BUY', FILLED_HANDLE_USD, null), null)) / nullif(sum(iff(SPORT_VS_OTHER <> 'COMBOS', iff(TRADE_ACTION = 'BUY', ATTEMPTED_HANDLE_USD, null), null)), 0) DIV_130, sum(iff(SPORT_VS_OTHER = 'COMBOS', iff(TRADE_ACTION = 'BUY', FILLED_HANDLE_USD, null), null)) / nullif(sum(iff(SPORT_VS_OTHER = 'COMBOS', iff(TRADE_ACTION = 'BUY', ATTEMPTED_HANDLE_USD, null), null)), 0) DIV_131 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where IS_TEST_ACCOUNT and not IS_TEST_ACCOUNT and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by DATETRUNC_125) Q1 order by DATETRUNC_125 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=rLE6Gx36P3","kind":"adhoc","request-id":"g019d73ea59f272a6bd81d7c5dc102cbf","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
