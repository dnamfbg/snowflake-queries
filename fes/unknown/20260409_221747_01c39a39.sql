-- Query ID: 01c39a39-0112-6b51-0000-e307218d41b2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:17:47.381000+00:00
-- Elapsed: 77ms
-- Environment: FES

select COUNT_12 "row-count" from (select count(1) COUNT_12 from FES_USERS.SANDBOX.FANAPP_PAID_SPEND) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=bOyYgHySPl","kind":"adhoc","request-id":"g019d7452a7d672aba26c19f850f9ee73","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
