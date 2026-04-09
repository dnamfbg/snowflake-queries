-- Query ID: 01c399cc-0112-6be5-0000-e3072189d50e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:22.594000+00:00
-- Elapsed: 83ms
-- Environment: FES

select DATETRUNC_5 "Date", SUM_8 L7, SUM_9 L30, SUM_7 L365 from (select date_trunc(day, "DATE"::timestamp_ltz) DATETRUNC_5, sum(L365_COUNT) SUM_7, sum(L7_COUNT) SUM_8, sum(L30_COUNT) SUM_9 from FES_USERS.SANDBOX.MVCS_BY_DAY where date_trunc(day, "DATE"::timestamp_ltz) >= to_timestamp_ltz('2026-03-19T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, "DATE"::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_5) Q1 order by DATETRUNC_5 desc nulls last limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=itDzY7wAeF","kind":"adhoc","request-id":"g019d73ee758479a691c122588127e60a","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
