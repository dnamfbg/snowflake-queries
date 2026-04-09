-- Query ID: 01c39a31-0112-6544-0000-e307218cc5ce
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:09:29.733000+00:00
-- Elapsed: 52ms
-- Environment: FES

select SWITCH_7 "Guest vs User", DATETRUNC_8 "Month", COUNTDISTINCT_9 "Distinct Ids" from (select case IS_GUEST_FLAG when 1 then 'Guest' when 0 then 'Identified' end SWITCH_7, date_trunc(day, "MONTH"::timestamp_ltz) DATETRUNC_8, count(distinct BRIDGE_IDENTITY_KEY) COUNTDISTINCT_9 from FES_USERS.CAROLINE_WYLIE.FANAPP_MONTHLY_ACTIVES where coalesce(IS_GUEST_FLAG <> 1, true) and "MONTH" >= to_timestamp_ntz('2026-04-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-30 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and case IS_GUEST_FLAG when 1 then 'Guest' when 0 then 'Identified' end is not null group by SWITCH_7, DATETRUNC_8) Q1 order by SWITCH_7 asc, DATETRUNC_8 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/FanApp-MAU-2BkDb8Xokp7JKzDCsdMD6L?:displayNodeId=Wk5aFlmcxB","kind":"adhoc","request-id":"g019d744b0ff67f54bbc236ce37abfcca","user-id":"761znsSQzXm3bXv3Md6ACqJN9CDcw","email":"caroline.wylie@betfanatics.com"}
