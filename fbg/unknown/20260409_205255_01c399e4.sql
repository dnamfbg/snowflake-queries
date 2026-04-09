-- Query ID: 01c399e4-0212-6b00-24dd-0703192dce1f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:52:55.607000+00:00
-- Elapsed: 927ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort", CAST_39 "Text Seach Column" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38, ACCO_ID::text CAST_39 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where contains(lower(ACCO_ID::text), lower('6571224')) group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d7404f31c7643b2f81321ec6261e1","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
