-- Query ID: 01c399f5-0212-644a-24dd-07031931b6a7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:09:03.757000+00:00
-- Elapsed: 405ms
-- Environment: FBG

select COUNTDISTINCT_193 "CountDistinct of WoW - 1st Bet Last 7 Days", COUNTDISTINCT_194 "CountDistinct of WoW - 1st Bet Last 14 to 7 Days", DIV_197 "WoW - 1st Bet % Change" from (select count(distinct iff(date_trunc(day, FBG_FTU_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'), ACCO_ID, null)) COUNTDISTINCT_193, count(distinct iff(date_trunc(day, FBG_FTU_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, FBG_FTU_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'), ACCO_ID, null)) COUNTDISTINCT_194, (COUNTDISTINCT_193 - COUNTDISTINCT_194) / nullif(COUNTDISTINCT_194, 0) DIV_197 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, date_trunc(day, FBG_FTU_DATE::timestamp_ltz)) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=rcLf7vhAY0","kind":"adhoc","request-id":"g019d7413b8c27cd18b04e3bfe3380273","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
