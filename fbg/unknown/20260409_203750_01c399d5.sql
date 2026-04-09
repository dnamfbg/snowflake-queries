-- Query ID: 01c399d5-0212-67a8-24dd-0703192ae36b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:37:50.767000+00:00
-- Elapsed: 414ms
-- Environment: FBG

select "ID" "Account ID", STATUS "Status" from (select distinct "ID", STATUS from FBG_ANALYTICS.OPERATIONS.ACCOUNT_STATUS_DS where "ID" = 6555370) Q1 order by STATUS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=10Dh05pQrd","kind":"adhoc","request-id":"g019d73f7266f78529696a0f932f3c951","user-id":"6l0KK4LlRFECilIxXwpUBg7v3O28P","email":"matthew.minervini@betfanatics.com"}
