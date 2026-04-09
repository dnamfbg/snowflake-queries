-- Query ID: 01c399cc-0112-6544-0000-e3072189c8da
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:11.439000+00:00
-- Elapsed: 76ms
-- Environment: FES

select SUM_37 "Sum of New Accounts" from (select sum(SUB_26) SUM_37 from (select DATETRUNC_23, lag(COUNT_24, 1) over ( order by DATETRUNC_23 desc nulls last) - COUNT_24 SUB_26 from (select date_trunc(day, SNAPSHOT_TS) DATETRUNC_23, count(PRIVATE_FAN_ID) COUNT_24 from FES_USERS.SANDBOX.F1_ATTRIBUTES_AUDITS group by DATETRUNC_23) Q1 qualify DATETRUNC_23 >= to_timestamp_ltz('2026-04-07T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and DATETRUNC_23 <= to_timestamp_ltz('2026-04-07T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q2) Q3

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=Bd89g1RPPt","kind":"adhoc","request-id":"g019d73ee49de773db459e6b8c4d05aba","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
