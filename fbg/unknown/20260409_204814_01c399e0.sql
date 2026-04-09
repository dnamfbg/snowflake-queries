-- Query ID: 01c399e0-0212-67a8-24dd-0703192d036b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:48:14.225000+00:00
-- Elapsed: 47012ms
-- Environment: FBG

select IF_88 "Max Timestamp", NULL_EQ_86 from (select equal_null(min(MAX_TIMESTAMP::timestamp_ltz), max(MAX_TIMESTAMP::timestamp_ltz)) NULL_EQ_86, iff(NULL_EQ_86, max(MAX_TIMESTAMP::timestamp_ltz), null) IF_88 from FBG_ANALYTICS.TRADING.FIELDBOOK_LIABILITIES) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Business-Mix-Dashboard-5fP8YLw5lzQDrgIeBMqCzm?:displayNodeId=zeMgtuDVQe","kind":"adhoc","request-id":"g019d7400aa507b748c2173cce1547fc8","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
