-- Query ID: 01c399f5-0212-6cb9-24dd-07031931d54f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:09:04.105000+00:00
-- Elapsed: 624ms
-- Environment: FBG

select COUNTDISTINCT_193 "CountDistinct of WoW - 1st Deposit Last 7 Days", COUNTDISTINCT_194 "CountDistinct of WoW - 1st Deposit Last 14 to 7 Days", DIV_197 "WoW - 1st Deposit % Change" from (select count(distinct iff(date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'), ACCO_ID, null)) COUNTDISTINCT_193, count(distinct iff(date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'), ACCO_ID, null)) COUNTDISTINCT_194, (COUNTDISTINCT_193 - COUNTDISTINCT_194) / nullif(COUNTDISTINCT_194, 0) DIV_197 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and (date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') or FIRST_DEPOSIT_DATE is null) and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=-4l3mbsPih","kind":"adhoc","request-id":"g019d7413b8c37f308809294e9cebe309","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
