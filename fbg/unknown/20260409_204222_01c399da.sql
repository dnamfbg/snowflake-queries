-- Query ID: 01c399da-0212-644a-24dd-0703192bbb0b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:22.411000+00:00
-- Elapsed: 74ms
-- Environment: FBG

select SUM_45 "$ Attempted Handle" from (select sum(iff(ORDER_STATUS = 'FAILED', ATTEMPTED_HANDLE_USD, null)) SUM_45 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=Ygnv3YgX9w","kind":"adhoc","request-id":"g019d73fb418c7765aec48cf6687d8bc3","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
