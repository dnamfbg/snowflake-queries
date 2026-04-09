-- Query ID: 01c399fe-0212-6dbe-24dd-07031933cd6b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:18:05.942000+00:00
-- Elapsed: 848ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort", CAST_39 "Text Seach Column" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38, ACCO_ID::text CAST_39 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where contains(lower(ACCO_ID::text), lower('835096')) group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d741bfdac7edfb5c33514714f870d","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
