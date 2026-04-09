-- Query ID: 01c39a2b-0212-6cb9-24dd-0703193ec0e7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:03:12.062000+00:00
-- Elapsed: 84ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_27 "TopK Count" from (select ACCO_ID, count(1) COUNT_27 from FBG_ANALYTICS.OPERATIONS.AGENT_GOODWILL_BONUSING group by ACCO_ID) Q1 order by COUNT_27 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Goodwill-Bonusing-Dashboard-75rWHjwO1U00w6mvW2Tvjr","kind":"adhoc","request-id":"g019d744547a67974aeed6b7d5e000c7f","user-id":"u7nAStDFLkeAhKqxpoHiQZvXJSwJQ","email":"michaela.moore@betfanatics.com"}
