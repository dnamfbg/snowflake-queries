-- Query ID: 01c399c5-0212-6cb9-24dd-07031927c093
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:21:53.970000+00:00
-- Elapsed: 653ms
-- Environment: FBG

select DIV_125 "% Success Rate Volume" from (select sum(FILLED_HANDLE_USD) / nullif(sum(ATTEMPTED_HANDLE_USD), 0) DIV_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where IS_TEST_ACCOUNT and not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=-pUuSx_YPd","kind":"adhoc","request-id":"g019d73e889c77cb58b2269aaa3b52533","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
