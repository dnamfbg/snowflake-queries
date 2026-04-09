-- Query ID: 01c39a43-0212-67a9-24dd-070319437eb7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:27:16.028000+00:00
-- Elapsed: 397ms
-- Environment: FBG

select IF_32 "Audit Notes Text" from (select distinct iff(AUDIT_NOTE_DATE is null, 'No audit notes available', ' ') IF_32 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 6440186) Q1 order by IF_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=CwRxewdSbd","kind":"adhoc","request-id":"g019d745b5280780fa55f8f2ca0717c51","user-id":"v3w6Et1KGW5yDANYQJyggsbZnGhoL","email":"joe.difonzo@betfanatics.com"}
