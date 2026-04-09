-- Query ID: 01c39a43-0212-6e7d-24dd-07031943bbd7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:27:15.895000+00:00
-- Elapsed: 341ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6440186) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d745b52807b9496740ff7d376cc99","user-id":"v3w6Et1KGW5yDANYQJyggsbZnGhoL","email":"joe.difonzo@betfanatics.com"}
