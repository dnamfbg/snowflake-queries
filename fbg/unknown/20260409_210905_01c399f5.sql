-- Query ID: 01c399f5-0212-6cb9-24dd-07031931d583
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:09:05.197000+00:00
-- Elapsed: 123ms
-- Environment: FBG

select COUNT_193 "Count of First Deposit Date" from (select count(FIRST_DEPOSIT_DATE::timestamp_ltz) COUNT_193 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and (date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') or FIRST_DEPOSIT_DATE is null) and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and FIRST_DEPOSIT_DATE >= to_timestamp_ntz('2026-04-02 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and FIRST_DEPOSIT_DATE <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=JGzA7Iz7J5","kind":"adhoc","request-id":"g019d7413bf22782ab9005488b6cc41c6","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
