-- Query ID: 01c399c9-0212-67a8-24dd-07031928501f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:25:10.559000+00:00
-- Elapsed: 166ms
-- Environment: FBG

select LEGS_PER_COMBO "Legs per Combo", COUNTDISTINCT_46 "CountDistinct of Order Id" from (select LEGS_PER_COMBO, count(distinct ORDER_ID) COUNTDISTINCT_46 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where IS_TEST_ACCOUNT and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by LEGS_PER_COMBO) Q1 order by LEGS_PER_COMBO desc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=br5V-NUV_b","kind":"adhoc","request-id":"g019d73eb8d2679e98f84484e00b249da","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
