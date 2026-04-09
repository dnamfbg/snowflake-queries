-- Query ID: 01c399d0-0212-6cb9-24dd-070319295e6b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:32:20.601000+00:00
-- Elapsed: 73ms
-- Environment: FBG

select SUM_45 "$ Attempted Handle" from (select sum(iff(ORDER_STATUS = 'FAILED', ATTEMPTED_HANDLE_USD, null)) SUM_45 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=Ygnv3YgX9w","kind":"adhoc","request-id":"g019d73f219cc7e22bfab2d370728f664","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
