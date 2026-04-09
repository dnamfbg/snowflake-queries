-- Query ID: 01c399f3-0212-6cb9-24dd-0703193159b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:07:58.484000+00:00
-- Elapsed: 131ms
-- Environment: FBG

select COUNT_193 "Count of First Deposit Date" from (select count(FIRST_DEPOSIT_DATE::timestamp_ltz) COUNT_193 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and (date_trunc(day, FIRST_DEPOSIT_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') or FIRST_DEPOSIT_DATE is null) and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and FIRST_DEPOSIT_DATE >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and FIRST_DEPOSIT_DATE <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=KaR4XRxEw7","kind":"adhoc","request-id":"g019d7412bb8a7a59b4ba603210125a6f","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
