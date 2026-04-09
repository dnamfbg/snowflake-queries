-- Query ID: 01c39a1f-0212-644a-24dd-0703193c07f7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:51:59.146000+00:00
-- Elapsed: 459ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort", CAST_39 "Text Seach Column" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38, ACCO_ID::text CAST_39 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where contains(lower(ACCO_ID::text), lower('6563474')) group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d743b051c72bdbd7746ef36e40412","user-id":"dvA9SYMIqL0snRgDJMPvFYBY4SyK2","email":"bowen.smith@betfanatics.com"}
