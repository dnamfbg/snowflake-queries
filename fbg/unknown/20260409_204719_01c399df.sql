-- Query ID: 01c399df-0212-6e7d-24dd-0703192cca13
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:47:19.026000+00:00
-- Elapsed: 369ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_33 "TopK Count", ISNULL_38 "TopK Null Sort", CAST_39 "Text Seach Column" from (select ACCO_ID, COUNT_33, ACCO_ID is null ISNULL_38, ACCO_ID::text CAST_39 from (select ACCO_ID, count(1) COUNT_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where contains(lower(ACCO_ID::text), lower('6386296')) group by ACCO_ID) Q1) Q2 order by ISNULL_38 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA","kind":"adhoc","request-id":"g019d73ffcfff7bfaa9b12db740a4cc65","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
