-- Query ID: 01c39a21-0212-6dbe-24dd-0703193c3c33
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:53:56.009000+00:00
-- Elapsed: 35486ms
-- Environment: FBG

select SPORT "TopK Value", COUNT_166 "TopK Count", ISNULL_171 "TopK Null Sort", SPORT_172 "Text Seach Column" from (select *, SPORT is null ISNULL_171, SPORT SPORT_172 from (select SPORT, count(1) COUNT_166 from FBG_ANALYTICS.TRADING.FIELDBOOK_LIABILITIES where EVENT_TIME >= to_timestamp_ntz('2026-04-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME <= to_timestamp_ntz('2026-05-31 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and contains(lower(SPORT), lower('golf')) and EVENT_TIME >= to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by SPORT) Q1) Q2 order by ISNULL_171 desc, COUNT_166 desc, SPORT asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Business-Mix-Dashboard-5fP8YLw5lzQDrgIeBMqCzm","kind":"adhoc","request-id":"g019d743ccdbc7a63a3a180a845de1c01","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
