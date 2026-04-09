-- Query ID: 01c399d8-0212-6e7d-24dd-0703192b0fe7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:40:31.202000+00:00
-- Elapsed: 54211ms
-- Environment: FBG

select CATEGORY "TopK Value", COUNT_13 "TopK Count", ISNULL_18 "TopK Null Sort" from (select *, CATEGORY is null ISNULL_18 from (select CATEGORY, count(1) COUNT_13 from FBG_REPORTS.REGULATORY.KY_DETAILED_DAILY where "Gaming Day" >= to_date('2026-04-01', 'YYYY-MM-DD') and "Gaming Day" <= to_date('2026-04-01', 'YYYY-MM-DD') group by CATEGORY) Q1) Q2 order by ISNULL_18 desc, COUNT_13 desc, CATEGORY asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/KY-Regulatory-Reporting-4gfQzcSoWlzRxtgGMSuZ8q","kind":"adhoc","request-id":"g019d73f999837964a2eb03e1581a639a","user-id":"DPKxzyCylYg9tiUNxNygASY92VR1B","email":"john.zhu@betfanatics.com"}
