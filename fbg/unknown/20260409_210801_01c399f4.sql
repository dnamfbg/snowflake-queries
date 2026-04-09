-- Query ID: 01c399f4-0212-67a8-24dd-0703193195c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:08:01.605000+00:00
-- Elapsed: 145ms
-- Environment: FBG

select COUNTDISTINCT_193 "CountDistinct of Acco Id" from (select count(distinct ACCO_ID) COUNTDISTINCT_193 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_GENERAL where not DUPLICATE_EXCLUDED_LIST_FLAG and date_trunc(day, REG_DATE::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and (case date_part(weekday_iso, to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) when 1 then 'Monday' when 2 then 'Tuesday' when 3 then 'Wednesday' when 4 then 'Thursday' when 5 then 'Friday' when 6 then 'Saturday' when 7 then 'Sunday' end = 'Monday' and date_trunc(week, REG_DATE::timestamp_ltz) = dateadd(day, -7, date_trunc(week, to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'))) or date_trunc(week, REG_DATE::timestamp_ltz) = date_trunc(week, to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'))) and iff(CHANNEL in ('PB Created Acct', 'PB Migrated FTU'), 'PB Migrated', CHANNEL) = 'Organic & Other') Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=bos0i2PG4F","kind":"adhoc","request-id":"g019d7412c77e7ba8841fcc3817ec759e","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
