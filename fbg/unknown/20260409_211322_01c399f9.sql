-- Query ID: 01c399f9-0212-644a-24dd-07031932f4ef
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:13:22.964000+00:00
-- Elapsed: 1298ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_18 "TopK Count", CAST_23 "Text Seach Column" from (select ACCO_ID, COUNT_18, ACCO_ID::text CAST_23 from (select ACCO_ID, count(1) COUNT_18 from FBG_ANALYTICS_DEV.ROHAN_GULATI.TEMPMILESTONESCS where contains(lower(ACCO_ID::text), lower('1363357')) group by ACCO_ID) Q1) Q2 order by ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Milestones-CS-Dashboard-jE9SdUSvtDfpHSJnGSv0O","kind":"adhoc","request-id":"g019d7417ac8b76f18b5172491e204cae","user-id":"6useOh6eJqLtUcfgP4w8RGGqFGcIS","email":"derek.dubose@betfanatics.com"}
