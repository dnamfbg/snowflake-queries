-- Query ID: 01c39a3b-0212-6e7d-24dd-070319427273
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:19:26.187000+00:00
-- Elapsed: 609ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 1061873) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d7454250f7ddda701c667aa8c090f","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
