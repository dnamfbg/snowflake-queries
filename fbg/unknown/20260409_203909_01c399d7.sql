-- Query ID: 01c399d7-0212-67a9-24dd-0703192afb73
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:39:09.193000+00:00
-- Elapsed: 292ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d73f856667aa892073523dcf9229b","user-id":"jq9eEM8S1jbljCS4KzxiXWhnVMGGN","email":"daniel.westerberg@betfanatics.com"}
