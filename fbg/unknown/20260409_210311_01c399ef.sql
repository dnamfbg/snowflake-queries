-- Query ID: 01c399ef-0212-6dbe-24dd-070319306497
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:11.868000+00:00
-- Elapsed: 152ms
-- Environment: FBG

select DATETRUNC_57 "Date", SUM_62 "100% CSAT", SUM_58 "80% CSAT", SUM_59 "60% CSAT", SUM_60 "40% CSAT", SUM_61 "20% CSAT" from (select date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) DATETRUNC_57, sum(iff(try_to_double(CSAT) = 4, 1, 0)) SUM_58, sum(iff(try_to_double(CSAT) = 3, 1, 0)) SUM_59, sum(iff(try_to_double(CSAT) = 2, 1, 0)) SUM_60, sum(iff(try_to_double(CSAT) = 1, 1, 0)) SUM_61, sum(iff(try_to_double(CSAT) = 5, 1, 0)) SUM_62 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where CASE_STATUS = 'Resolved' and CASE_TYPE = 'Casino Errors' and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(month, CLOSED_DATE::timestamp_ltz)) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_57) Q1 order by DATETRUNC_57 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=w7XtmZ8Um7","kind":"adhoc","request-id":"g019d740e5d08729f83288fc4ed7ebed3","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
