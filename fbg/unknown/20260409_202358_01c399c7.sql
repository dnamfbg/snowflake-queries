-- Query ID: 01c399c7-0212-644a-24dd-0703192815b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:58.224000+00:00
-- Elapsed: 135ms
-- Environment: FBG

select LEG_MARKET_TYPES_COMBO_46 "Most Frequent Combinations", SUM_47 "Sum of Attempted Quantity", SUM_48 "sort-dnOnREdAly-0" from (select LEG_MARKET_TYPES_COMBO_46, SUM_47, SUM_48 from (select LEG_MARKET_TYPES_COMBO_46, SUM_47, SUM_47 SUM_48, rank() over ( order by LEG_MARKET_TYPES_COMBO_46 desc) RANK_50 from (select LEG_MARKET_TYPES_COMBO LEG_MARKET_TYPES_COMBO_46, sum(ATTEMPTED_QUANTITY) SUM_47 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where IS_TEST_ACCOUNT and LEG_MARKET_TYPES_COMBO is not null and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by LEG_MARKET_TYPES_COMBO) Q1 qualify RANK_50 <= 10) Q2) Q3 order by SUM_48 desc, LEG_MARKET_TYPES_COMBO_46 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=GbThDcOpa0","kind":"adhoc","request-id":"g019d73ea70b07277a6e17c325c214a51","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
