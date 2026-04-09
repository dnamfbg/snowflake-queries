-- Query ID: 01c39a3a-0212-6dbe-24dd-07031942364f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:18:58.245000+00:00
-- Elapsed: 702ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_18 "TopK Count", CAST_23 "Text Seach Column" from (select ACCO_ID, COUNT_18, ACCO_ID::text CAST_23 from (select ACCO_ID, count(1) COUNT_18 from FBG_ANALYTICS_DEV.ROHAN_GULATI.TEMPMILESTONESCS where contains(lower(ACCO_ID::text), lower('299144')) group by ACCO_ID) Q1) Q2 order by ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Milestones-CS-Dashboard-jE9SdUSvtDfpHSJnGSv0O","kind":"adhoc","request-id":"g019d7453b8fc72809b95dc18b57d1302","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
