-- Query ID: 01c39a2d-0212-67a8-24dd-0703193f27a3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:05:59.677000+00:00
-- Elapsed: 3872ms
-- Environment: FBG

select DATETRUNC_21 "Minute of Time", CAST_16 "Account Balance" from (select try_to_double(substring(split_part(RAW_MESSAGE, '', 17), 6)) CAST_16, date_trunc(minute, convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 6), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz) DATETRUNC_21 from FMX_ANALYTICS.STAGING.STG_FMX_MM_FIX_INBOUND_MESSAGES_SCD where MSG_TYPE = 'CQ' and date_trunc(minute, convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 6), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz) is not null and date_trunc(minute, convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 6), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz) >= to_timestamp_ltz('2026-04-03T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(minute, convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 6), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 order by DATETRUNC_21 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Market-Maker-Trading-6R2FxbRY8q4N3ynnXwEGa0?:displayNodeId=fL2PHvMm2q","kind":"adhoc","request-id":"g019d7447db38759eac4ac5a3fc4eaf17","user-id":"Zaj53AHEk1C5XVAfcwbJObHz5Z4PM","email":"zach.spergel@betfanatics.com"}
