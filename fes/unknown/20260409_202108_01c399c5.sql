-- Query ID: 01c399c5-0112-6806-0000-e3072189730a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:21:08.942000+00:00
-- Elapsed: 101ms
-- Environment: FES

select OPCO "TopK Value", COUNT_41 "TopK Count" from (select Q1.OPCO, count(1) COUNT_41 from (select * from ENTERPRISE_METRICS.REPORTING.ENTERPRISE_METRICS where QUARTER_TTM in ('Q2 25 TTM', 'Q3 25 TTM', 'Q4 25 TTM', 'Q1 26 TTM')) Q1 left join ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM Q2 on Q1.QUARTER_TTM = Q2.PERIOD_LABEL group by Q1.OPCO) Q4 order by COUNT_41 asc, OPCO asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Enterprise-Metrics-WIP-2Y2t0uQg9s6n1AEcuwZcLR","kind":"adhoc","request-id":"g019d73e7ddfc70998f66b877da0da5b7","user-id":"Bhth11jrGBRKCyrSjOioXAYLG6mU4","email":"stacy.lin@betfanatics.com"}
