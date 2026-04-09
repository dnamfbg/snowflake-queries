-- Query ID: 01c399c7-0212-67a8-24dd-07031927d6ab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:11.552000+00:00
-- Elapsed: 189ms
-- Environment: FBG

select DIV_125 "% Success Rate Volume" from (select sum(FILLED_HANDLE_USD) / nullif(sum(ATTEMPTED_HANDLE_USD), 0) DIV_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=-pUuSx_YPd","kind":"adhoc","request-id":"g019d73e9bc577f95aff4dc44556de75b","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
