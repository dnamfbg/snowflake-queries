-- Query ID: 01c39a05-0212-67a9-24dd-07031935a7f7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:25:01.803000+00:00
-- Elapsed: 6037ms
-- Environment: FBG

select MID_16 "Symbol", SWITCH_24 "Side", CAST_26 "Price", CAST_25 "Quantity", SWITCH_27 "Handle", CONVERTTIMEZONE_19 "Trade Time (US Eastern)" from (select substring(split_part(RAW_MESSAGE, '', 20), 4) MID_16, convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 22), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz CONVERTTIMEZONE_19, case substring(split_part(RAW_MESSAGE, '', 19), 4) when '2' then 'Ask' when '1' then 'Bid' end SWITCH_24, try_to_double(substring(split_part(RAW_MESSAGE, '', 13), 4)) CAST_25, try_to_double(substring(split_part(RAW_MESSAGE, '', 18), 4)) CAST_26, case SWITCH_24 when 'Ask' then CAST_26 * CAST_25 when 'Bid' then (1 - CAST_26) * CAST_25 end SWITCH_27 from FMX_ANALYTICS.STAGING.STG_FMX_MM_FIX_INBOUND_MESSAGES_SCD where contains(lower(RAW_MESSAGE), lower('150=F')) and convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 22), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz >= to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(RAW_MESSAGE, '', 22), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 order by CONVERTTIMEZONE_19 desc nulls last limit 136101

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Market-Maker-Trading-6R2FxbRY8q4N3ynnXwEGa0?:displayNodeId=6fKEAfpNUS","kind":"adhoc","request-id":"g019d742258287458b0a693a2d7977691","user-id":"Zaj53AHEk1C5XVAfcwbJObHz5Z4PM","email":"zach.spergel@betfanatics.com"}
