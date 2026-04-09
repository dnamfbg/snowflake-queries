-- Query ID: 01c399ec-0212-6e7d-24dd-0703192fb30f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:00:53.179000+00:00
-- Elapsed: 164ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS) Q1 order by "ID" asc, STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d740c3c137bb2b26b1be5ab389a75","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
