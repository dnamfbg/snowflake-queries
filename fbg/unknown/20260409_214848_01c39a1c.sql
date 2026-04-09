-- Query ID: 01c39a1c-0212-6dbe-24dd-0703193b3a47
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:48:48.150000+00:00
-- Elapsed: 69545ms
-- Environment: FBG

select SEL "Sel", DIV_96 "% SGP Bets - Overall", DIV_94 "% SGP Handle - Overall", DIV_93 "% SGP Bets - Event", DIV_95 "% SGP Handle - Event", DIV_92 "sort-inode-2pJYMEH4ESHUAqK48E61mz/SEL-0" from (select SEL, sum(BETS_SGP) / nullif(sum(SGP_BETS), 0) DIV_92, sum(BETS_SGP) / nullif(sum(SGP_BETS_EVENT), 0) DIV_93, sum(TOTAL_HANDLE_BET_SGP) / nullif(sum(O_SGP_HANDLE), 0) DIV_94, sum(TOTAL_HANDLE_BET_SGP) / nullif(sum(SGP_HANDLE_EVENT), 0) DIV_95, DIV_92 DIV_96 from FBG_ANALYTICS.TRADING.FIELDBOOK_LIABILITIES where EVENT_TIME >= to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_TIME <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by SEL) Q1 order by DIV_92 desc nulls last, SEL asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Business-Mix-Dashboard-5fP8YLw5lzQDrgIeBMqCzm?:displayNodeId=orTJyiQwNx","kind":"adhoc","request-id":"g019d74381cbe7a2a94c8b9496de7a7f7","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
