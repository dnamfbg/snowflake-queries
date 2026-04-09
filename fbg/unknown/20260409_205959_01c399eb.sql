-- Query ID: 01c399eb-0212-67a9-24dd-0703192f2d53
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:59:59.136000+00:00
-- Elapsed: 126ms
-- Environment: FBG

select DATETRUNC_57 "Date", AVG_58 "CSAT %", DIV_61 "CSAT+" from (select date_trunc(day, dateadd(day, 1, dateadd('day', -1, date_trunc(week, dateadd('day', 1, dateadd(day, -1, CLOSED_DATE::timestamp_ltz)))))) DATETRUNC_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_61 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where CASE_STATUS = 'Resolved' and CASE_TYPE in ('Casino Promotions', 'Casino Errors', 'iCasino', 'Casino Spin to Win', 'Casino Payout', 'Casino Credit') and iff(CASE_SOURCE = 'Inbound: ChatBot', 'Bot', 'Agent') = 'Agent' and date_trunc(day, dateadd(day, 1, dateadd('day', -1, date_trunc(week, dateadd('day', 1, dateadd(day, -1, CLOSED_DATE::timestamp_ltz)))))) >= to_timestamp_ltz('2026-04-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, dateadd(day, 1, dateadd('day', -1, date_trunc(week, dateadd('day', 1, dateadd(day, -1, CLOSED_DATE::timestamp_ltz)))))) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_57) Q1 order by DATETRUNC_57 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=MBhrDOK5zL","kind":"adhoc","request-id":"g019d740b6c2b7453a3b5d0c2d1f7845e","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
