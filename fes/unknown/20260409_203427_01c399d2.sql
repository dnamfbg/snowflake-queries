-- Query ID: 01c399d2-0112-6be5-0000-e3072189d712
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:34:27.051000+00:00
-- Elapsed: 96ms
-- Environment: FES

select OPCO_18 "Opco", QUARTER_TTM_19 "Quarter Ttm", SUM_17 "Sum of Aov", MIN_13 "sort-Jb62oI-f6l-0" from (select MIN_13, SUM_17, OPCO_18, QUARTER_TTM_19 from (select Q4.SUM_17, Q4.OPCO_18, Q4.QUARTER_TTM_19, Q8.MIN_13, Q8.QUARTER_TTM_15 from (select sum(Q1.AOV) SUM_17, Q1.OPCO OPCO_18, Q1.QUARTER_TTM QUARTER_TTM_19 from (select * from ENTERPRISE_METRICS.REPORTING.ENTERPRISE_METRICS where OPCO in ('Comm All', 'FBG All') and QUARTER_TTM in ('Q2 25 TTM', 'Q3 25 TTM', 'Q4 25 TTM', 'Q1 26 TTM')) Q1 left join ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM Q2 on Q1.QUARTER_TTM = Q2.PERIOD_LABEL group by Q1.QUARTER_TTM, Q1.OPCO) Q4 left join (select min(Q6.PERIOD_START::timestamp_ltz) MIN_13, Q5.QUARTER_TTM QUARTER_TTM_15 from (select * from ENTERPRISE_METRICS.REPORTING.ENTERPRISE_METRICS where OPCO in ('Comm All', 'FBG All') and QUARTER_TTM in ('Q2 25 TTM', 'Q3 25 TTM', 'Q4 25 TTM', 'Q1 26 TTM')) Q5 left join ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM Q6 on Q5.QUARTER_TTM = Q6.PERIOD_LABEL group by Q5.QUARTER_TTM) Q8 on Q4.QUARTER_TTM_19 = Q8.QUARTER_TTM_15 order by Q4.OPCO_18 asc, Q8.MIN_13 asc nulls last, Q4.QUARTER_TTM_19 asc limit 25001) Q10) Q11 order by OPCO_18 asc, MIN_13 asc nulls last, QUARTER_TTM_19 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Enterprise-Metrics-WIP-2Y2t0uQg9s6n1AEcuwZcLR?:displayNodeId=eXMR9cVqdS","kind":"adhoc","request-id":"g019d73f40ba27a708e8ea79331e2c901","user-id":"Bhth11jrGBRKCyrSjOioXAYLG6mU4","email":"stacy.lin@betfanatics.com"}
