-- Query ID: 01c39a07-0212-67a8-24dd-07031936338b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:27:28.231000+00:00
-- Elapsed: 257ms
-- Environment: FBG

select IF_32 "Audit Notes Text" from (select distinct iff(AUDIT_NOTE_DATE is null, 'No audit notes available', ' ') IF_32 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 6552785) Q1 order by IF_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=CwRxewdSbd","kind":"adhoc","request-id":"g019d7424950276ddb23123f15918ffec","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
