-- Query ID: 01c399f4-0212-67a8-24dd-070319319593
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:08:00.260000+00:00
-- Elapsed: 150ms
-- Environment: FBG

select COUNTDISTINCT_193 "CountDistinct of Acco Id" from (select count(distinct ACCO_ID) COUNTDISTINCT_193 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and iff(CHANNEL in ('PB Created Acct', 'PB Migrated FTU'), 'PB Migrated', CHANNEL) = 'Organic & Other' and REG_DATE >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and REG_DATE <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=M_lKGG9dXK","kind":"adhoc","request-id":"g019d7412bb8b71768f26871a2277fdbc","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
