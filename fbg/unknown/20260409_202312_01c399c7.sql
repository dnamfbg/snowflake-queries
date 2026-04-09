-- Query ID: 01c399c7-0212-67a8-24dd-07031927d6cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:12.147000+00:00
-- Elapsed: 186ms
-- Environment: FBG

select SUM_123 "$ Attempted Handle" from (select sum(iff(ORDER_STATUS = 'FAILED', ATTEMPTED_HANDLE_USD, null)) SUM_123 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=lxvznDftG2","kind":"adhoc","request-id":"g019d73e9bc5771a3955a73644177466f","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
