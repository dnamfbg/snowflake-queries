-- Query ID: 01c39a06-0212-644a-24dd-07031935e33b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:26:04.308000+00:00
-- Elapsed: 52ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_27 "TopK Count" from (select ACCO_ID, count(1) COUNT_27 from FBG_ANALYTICS.OPERATIONS.AGENT_GOODWILL_BONUSING group by ACCO_ID) Q1 order by COUNT_27 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Goodwill-Bonusing-Dashboard-75rWHjwO1U00w6mvW2Tvjr","kind":"adhoc","request-id":"g019d74234cac76ac97b1b202e55b9b09","user-id":"Wm5FtO70fxzoLV7v276qGgKUHaido","email":"sky.krokus@betfanatics.com"}
