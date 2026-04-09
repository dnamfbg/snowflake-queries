-- Query ID: 01c39a09-0112-6be5-0000-e307218b2ef6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:29:55.878000+00:00
-- Elapsed: 66ms
-- Environment: FES

select CAST_6 "Month", BRIDGE_IDENTITY_KEY "Bridge Identity Key", IS_GUEST_FLAG "Is Guest Flag", LOYALTY_TIER "Loyalty Tier", CUSTOMER_SEGMENT "Customer Segment", COALESCE_5 "Guest" from (select BRIDGE_IDENTITY_KEY, IS_GUEST_FLAG, LOYALTY_TIER, CUSTOMER_SEGMENT, coalesce(IS_GUEST_FLAG <> 1, true) COALESCE_5, "MONTH"::timestamp_ltz CAST_6 from FES_USERS.CAROLINE_WYLIE.FANAPP_MONTHLY_ACTIVES where "MONTH" >= to_timestamp_ntz('2025-05-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-30 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "MONTH" <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/FanApp-MAU-2BkDb8Xokp7JKzDCsdMD6L?:displayNodeId=M85Kc0BXL1","kind":"adhoc","request-id":"g019d7426d6dd7d76a1d40574d2952e25","user-id":"761znsSQzXm3bXv3Md6ACqJN9CDcw","email":"caroline.wylie@betfanatics.com"}
