-- Query ID: 01c399f2-0212-67a8-24dd-07031931191f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:06:36.316000+00:00
-- Elapsed: 143ms
-- Environment: FBG

select DATETRUNC_57 "Date", AVG_58 "CSAT %", DIV_66 "CSAT+", SUM_59 "100% CSAT", SUM_60 "80% CSAT", SUM_61 "60% CSAT", SUM_62 "40% CSAT", SUM_63 "20% CSAT" from (select date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) DATETRUNC_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) = 5, 1, 0)) SUM_59, sum(iff(try_to_double(CSAT) = 4, 1, 0)) SUM_60, sum(iff(try_to_double(CSAT) = 3, 1, 0)) SUM_61, sum(iff(try_to_double(CSAT) = 2, 1, 0)) SUM_62, sum(iff(try_to_double(CSAT) = 1, 1, 0)) SUM_63, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_66 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where AGENT_NAME = 'Ashley Dejesus' and CASE_STATUS = 'Resolved' and CASE_TYPE in ('Casino Errors', 'Casino Promotions', 'iCasino', 'Casino Payout', 'Casino Spin to Win', 'Casino Credit', 'Casino Integrity/Rules', 'Casino FanCash Spins', 'Casino Support', 'Casino Promotion', 'missing casino credit') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_57) Q1 order by DATETRUNC_57 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=dtqDIt72xb","kind":"adhoc","request-id":"g019d7411785673938afc803cc74ccd96","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
