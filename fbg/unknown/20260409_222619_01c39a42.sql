-- Query ID: 01c39a42-0212-67a8-24dd-07031943a7d3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:26:19.412000+00:00
-- Elapsed: 7714ms
-- Environment: FBG

select MID_19 "Symbol", TITLE "Title", MAX_20 "Latest Quote Time (US Eastern)" from (select Q1.MID_19, Q1.MAX_20, Q2.TITLE from (select substring(split_part(MESSAGE, '', 15), 4) MID_19, max(convert_timezone('UTC', 'America/New_York', try_to_timestamp_ltz(substring(split_part(MESSAGE, '', 6), 4), 'YYYYMMDD"-"HH24":"MI":"SS"."FF3')::timestamp_ntz)::timestamp_ltz) MAX_20 from FMX_ANALYTICS.STAGING.STG_FMX_MM_FIX_MESSAGES where contains(lower(MESSAGE), lower('35=i')) group by MID_19 having MAX_20 >= to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and MAX_20 <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 left join FBG_SOURCE.FMX_SOURCE.CRYPTO_MARKETS Q2 on Q1.MID_19 = Q2.SYMBOL) Q4 order by MAX_20 desc nulls last limit 95301

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Market-Maker-Trading-6R2FxbRY8q4N3ynnXwEGa0?:displayNodeId=bZqTNAOfdA","kind":"adhoc","request-id":"g019d745a752f7597bc9c1e4ac658a187","user-id":"Zaj53AHEk1C5XVAfcwbJObHz5Z4PM","email":"zach.spergel@betfanatics.com"}
