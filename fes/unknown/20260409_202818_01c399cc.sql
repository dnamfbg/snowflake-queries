-- Query ID: 01c399cc-0112-6db7-0000-e30721896f5a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:18.968000+00:00
-- Elapsed: 59ms
-- Environment: FES

select LOYALTY_TIER_29 "Loyalty Tier", COUNT_31 "sort--bkUZliNj2-0", DATETRUNC_30 "Day of Snapshot Ts", COUNT_28 "Count of Private Fan Id" from (select COUNT_28, LOYALTY_TIER_29, DATETRUNC_30, COUNT_31 from (select Q1.COUNT_28, Q1.LOYALTY_TIER_29, Q1.DATETRUNC_30, Q2.COUNT_31, Q2.LOYALTY_TIER_32 from (select count(PRIVATE_FAN_ID) COUNT_28, LOYALTY_TIER LOYALTY_TIER_29, date_trunc(day, SNAPSHOT_TS) DATETRUNC_30 from FES_USERS.SANDBOX.F1_ATTRIBUTES_AUDITS where LOYALTY_TIER in ('ONE gold', 'ONE platinum', 'ONE black') and date_trunc(day, SNAPSHOT_TS) >= to_timestamp_ltz('2026-03-31T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, SNAPSHOT_TS) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by LOYALTY_TIER, DATETRUNC_30) Q1 left join (select count(PRIVATE_FAN_ID) COUNT_31, LOYALTY_TIER LOYALTY_TIER_32 from FES_USERS.SANDBOX.F1_ATTRIBUTES_AUDITS where LOYALTY_TIER in ('ONE gold', 'ONE platinum', 'ONE black') and date_trunc(day, SNAPSHOT_TS) >= to_timestamp_ltz('2026-03-31T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, SNAPSHOT_TS) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by LOYALTY_TIER) Q2 on Q1.LOYALTY_TIER_29 = Q2.LOYALTY_TIER_32 order by Q2.COUNT_31 asc, Q1.LOYALTY_TIER_29 asc, Q1.DATETRUNC_30 asc limit 25001) Q4) Q5 order by COUNT_31 asc, LOYALTY_TIER_29 asc, DATETRUNC_30 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=YrT3W4QR8b","kind":"adhoc","request-id":"g019d73ee6756794186ace3f06c84ca9b","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
