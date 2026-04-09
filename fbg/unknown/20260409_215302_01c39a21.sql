-- Query ID: 01c39a21-0212-644a-24dd-0703193c0f4b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:53:02.354000+00:00
-- Elapsed: 52309ms
-- Environment: FBG

select COMP "TopK Value", COUNT_166 "TopK Count", ISNULL_171 "TopK Null Sort" from (select *, COMP is null ISNULL_171 from (select COMP, count(1) COUNT_166 from FBG_ANALYTICS.TRADING.FIELDBOOK_LIABILITIES where EVENT_TIME >= to_timestamp_ntz('2026-04-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME <= to_timestamp_ntz('2026-05-31 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME >= to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by COMP) Q1) Q2 order by ISNULL_171 desc, COUNT_166 desc, COMP asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Business-Mix-Dashboard-5fP8YLw5lzQDrgIeBMqCzm","kind":"adhoc","request-id":"g019d743bfdea710fa12cb295d59af627","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
