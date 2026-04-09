-- Query ID: 01c39a50-0212-6e7d-24dd-070319468d7f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:40:26.195000+00:00
-- Elapsed: 344ms
-- Environment: FBG

select IF_32 "Audit Notes Text" from (select distinct iff(AUDIT_NOTE_DATE is null, 'No audit notes available', ' ') IF_32 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 1350455) Q1 order by IF_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=CwRxewdSbd","kind":"adhoc","request-id":"g019d7467603a7395b9577aaa7dee28b0","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
