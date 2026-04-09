-- Query ID: 01c399da-0212-67a8-24dd-0703192c00e7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:20.935000+00:00
-- Elapsed: 111ms
-- Environment: FBG

select DIV_47 "% Success Rate Volume" from (select sum(FILLED_HANDLE_USD) / nullif(sum(ATTEMPTED_HANDLE_USD), 0) DIV_47 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=CzwpBWq3dX","kind":"adhoc","request-id":"g019d73fb418d742f97771e187054a418","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
