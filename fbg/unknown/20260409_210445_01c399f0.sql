-- Query ID: 01c399f0-0212-6dbe-24dd-070319306e97
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:04:45.374000+00:00
-- Elapsed: 318ms
-- Environment: FBG

select COUNT_596 "row-count" from (select count(1) COUNT_596 from FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART where WAGER_PLACED_TIME_EST >= to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and WAGER_PLACED_TIME_EST <= to_timestamp_ntz('2026-04-09 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Bet-Search-1yQLSChQtrc02XvcJxcfu3?:displayNodeId=aAuPoa8NMm","kind":"adhoc","request-id":"g019d740fc7d075d2825aaed006ce7ddf","user-id":"uAqFr6PtMFltjQQbE00o1UrMZqdHm","email":"tony.ditirro@betfanatics.com"}
