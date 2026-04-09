-- Query ID: 01c399d5-0212-644a-24dd-0703192a8e27
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:37:59.993000+00:00
-- Elapsed: 107ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6554568) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d73f74a557a25859140c00a2d5b66","user-id":"6l0KK4LlRFECilIxXwpUBg7v3O28P","email":"matthew.minervini@betfanatics.com"}
