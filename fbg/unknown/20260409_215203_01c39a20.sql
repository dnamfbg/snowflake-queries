-- Query ID: 01c39a20-0212-67a8-24dd-0703193c428f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:52:03.317000+00:00
-- Elapsed: 303ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6563474) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d743b158e74b8bd0182bdf1ef8301","user-id":"dvA9SYMIqL0snRgDJMPvFYBY4SyK2","email":"bowen.smith@betfanatics.com"}
