-- Query ID: 01c399ef-0212-6dbe-24dd-0703193064d3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:13.566000+00:00
-- Elapsed: 1976ms
-- Environment: FBG

select DATETRUNC_47 "Date", DIV_50 "CSAT Participation Rate", COUNTDISTINCT_48 "Total Cases Closed" from (select date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) DATETRUNC_47, count(distinct CASE_NUMBER) COUNTDISTINCT_48, sum(iff(CSAT_SCORE is not null, 1, 0)) / nullif(COUNTDISTINCT_48, 0) DIV_50 from FBG_ANALYTICS.OPERATIONS.PARTICIPATION_RATE_CSAT where (not CASE_SOURCE in ('Support Site', 'FMX - Voicemail', 'FMX - Email') or CASE_SOURCE is null) and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_47) Q1 order by DATETRUNC_47 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=KHoo7qGBdq","kind":"adhoc","request-id":"g019d740e63b7750d8c84f3d1403dbcd5","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
