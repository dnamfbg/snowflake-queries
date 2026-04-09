-- Query ID: 01c39a33-0212-6cb9-24dd-07031940b0bb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:11:01.280000+00:00
-- Elapsed: 739ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6565455) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d744c740d7ef8b5ca58c5c2fb5529","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
