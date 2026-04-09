-- Query ID: 01c39a1f-0212-6e7d-24dd-0703193bdb87
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:51:16.902000+00:00
-- Elapsed: 338ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6547290) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d743a60637600a749355b8c4aa15b","user-id":"dvA9SYMIqL0snRgDJMPvFYBY4SyK2","email":"bowen.smith@betfanatics.com"}
