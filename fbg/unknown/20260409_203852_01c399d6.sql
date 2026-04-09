-- Query ID: 01c399d6-0212-6e7d-24dd-0703192b055b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:38:52.825000+00:00
-- Elapsed: 1172ms
-- Environment: FBG

select IF_32 "Audit Notes Text" from (select distinct iff(AUDIT_NOTE_DATE is null, 'No audit notes available', ' ') IF_32 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 3213501) Q1 order by IF_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=CwRxewdSbd","kind":"adhoc","request-id":"g019d73f817d9722781c44a6e80649f0e","user-id":"jq9eEM8S1jbljCS4KzxiXWhnVMGGN","email":"daniel.westerberg@betfanatics.com"}
