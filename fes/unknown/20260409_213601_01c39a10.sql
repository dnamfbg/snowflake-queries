-- Query ID: 01c39a10-0112-65b6-0000-e307218b5c66
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:36:01.314000+00:00
-- Elapsed: 3393ms
-- Environment: FES

with W1 as (select BRIDGE_IDENTITY_KEY, LOYALTY_TIER, "MONTH"::timestamp_ltz CAST_6 from FES_USERS.CAROLINE_WYLIE.FANAPP_MONTHLY_ACTIVES where coalesce(IS_GUEST_FLAG <> 1, true) and "MONTH" >= to_timestamp_ntz('2025-05-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-30 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) select LOYALTY_TIER_11 "Loyalty Tier", COUNTDISTINCT_13 "sort-DzH8eMh7O6-0", DATETRUNC_12 "Day of Month", COUNTDISTINCT_10 "Distinct Ids" from (select COUNTDISTINCT_10, LOYALTY_TIER_11, DATETRUNC_12, COUNTDISTINCT_13 from (select Q3.COUNTDISTINCT_10, Q3.LOYALTY_TIER_11, Q3.DATETRUNC_12, Q5.COUNTDISTINCT_13, Q5.LOYALTY_TIER_14 from (select count(distinct BRIDGE_IDENTITY_KEY) COUNTDISTINCT_10, LOYALTY_TIER LOYALTY_TIER_11, date_trunc(day, CAST_6) DATETRUNC_12 from W1 Q2 group by DATETRUNC_12, LOYALTY_TIER) Q3 left join (select count(distinct BRIDGE_IDENTITY_KEY) COUNTDISTINCT_13, LOYALTY_TIER LOYALTY_TIER_14 from W1 Q4 group by LOYALTY_TIER) Q5 on equal_null(Q3.LOYALTY_TIER_11, Q5.LOYALTY_TIER_14) order by Q5.COUNTDISTINCT_13 asc, Q3.LOYALTY_TIER_11 asc, Q3.DATETRUNC_12 asc limit 25001) Q7) Q8 order by COUNTDISTINCT_13 asc, LOYALTY_TIER_11 asc, DATETRUNC_12 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/FanApp-MAU-2BkDb8Xokp7JKzDCsdMD6L?:displayNodeId=sfcO0SgL6J","kind":"adhoc","request-id":"g019d742c68aa7bf0ac312857e1b19846","user-id":"761znsSQzXm3bXv3Md6ACqJN9CDcw","email":"caroline.wylie@betfanatics.com"}
