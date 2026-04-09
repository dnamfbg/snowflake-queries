-- Query ID: 01c399f2-0212-644a-24dd-07031930ef87
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:06:35.503000+00:00
-- Elapsed: 122ms
-- Environment: FBG

select DATETRUNC_57 "Date", AVG_58 "CSAT %", DIV_61 "CSAT+" from (select date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) DATETRUNC_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_61 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where AGENT_NAME = 'Ashley Dejesus' and CASE_STATUS = 'Resolved' and CASE_TYPE in ('Casino Errors', 'Casino Promotions', 'iCasino', 'Casino Payout', 'Casino Spin to Win', 'Casino Credit', 'Casino Integrity/Rules', 'Casino FanCash Spins', 'Casino Support', 'Casino Promotion', 'missing casino credit') and iff(CASE_SOURCE = 'Inbound: ChatBot', 'Bot', 'Agent') = 'Agent' and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_57) Q1 order by DATETRUNC_57 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=MBhrDOK5zL","kind":"adhoc","request-id":"g019d7411785672d3a22b21b8f48845f5","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
