-- Query ID: 01c399f0-0212-67a9-24dd-07031930c423
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:04:49.094000+00:00
-- Elapsed: 161ms
-- Environment: FBG

select DATETRUNC_57 "Date", AVG_58 "CSAT %", DIV_61 "CSAT+" from (select date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) DATETRUNC_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_61 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where AGENT_NAME in ('Brett Hooper', 'Paul Plescia', 'Victor Centeno Fernandez', 'Enmanuel Tavarez', 'Darren Rajcoomar', 'KC Bitterman') and CASE_STATUS = 'Resolved' and CASE_TYPE = 'Casino Errors' and iff(CASE_SOURCE = 'Inbound: ChatBot', 'Bot', 'Agent') = 'Bot' and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_57) Q1 order by DATETRUNC_57 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=9MlRVH_C2g","kind":"adhoc","request-id":"g019d740fd8bc79ae8cc806e1d2044c8b","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
