-- Query ID: 01c399cd-0112-6db7-0000-e30721896fd6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:29:32.592000+00:00
-- Elapsed: 864ms
-- Environment: FES

select QUARTER_TTM "TopK Value", COUNT_41 "TopK Count", MIN_42 "Period Start" from (select Q1.QUARTER_TTM, count(1) COUNT_41, min(Q2.PERIOD_START::timestamp_ltz) MIN_42 from (select * from ENTERPRISE_METRICS.REPORTING.ENTERPRISE_METRICS where OPCO = 'FBG Only') Q1 left join ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM Q2 on Q1.QUARTER_TTM = Q2.PERIOD_LABEL group by Q1.QUARTER_TTM) Q4 order by MIN_42 asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Enterprise-Metrics-WIP-2Y2t0uQg9s6n1AEcuwZcLR","kind":"adhoc","request-id":"g019d73ef8d5b7470b25eb9d8418aed75","user-id":"Bhth11jrGBRKCyrSjOioXAYLG6mU4","email":"stacy.lin@betfanatics.com"}
