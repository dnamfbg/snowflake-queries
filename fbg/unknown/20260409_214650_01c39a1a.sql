-- Query ID: 01c39a1a-0212-6dbe-24dd-0703193b3093
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:46:50.787000+00:00
-- Elapsed: 144ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d7436526c7f04ac70e3cd5fc9a25b","user-id":"UioxYAFK9jeRWNH3P6JB3zVOYI6Wy","email":"marquise.owens@betfanatics.com"}
