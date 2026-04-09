-- Query ID: 01c399f5-0212-67a9-24dd-07031931eb07
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:09:48.103000+00:00
-- Elapsed: 99ms
-- Environment: FBG

select COUNTDISTINCT_193 "CountDistinct of Acco Id" from (select count(distinct ACCO_ID) COUNTDISTINCT_193 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and iff(CHANNEL in ('PB Created Acct', 'PB Migrated FTU'), 'PB Migrated', CHANNEL) = 'Organic & Other') Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=LQSYCklJY6","kind":"adhoc","request-id":"g019d7414664a78929f462371c3e2f0cb","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
