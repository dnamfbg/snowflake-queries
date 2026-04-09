-- Query ID: 01c39a55-0112-6f82-0000-e307218d0f5a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:45:43.016000+00:00
-- Elapsed: 77ms
-- Environment: FES

select AUDIENCE_NAME "TopK Value", COUNT_23 "TopK Count" from (select AUDIENCE_NAME, count(1) COUNT_23 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS group by AUDIENCE_NAME) Q1 order by COUNT_23 desc, AUDIENCE_NAME asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw","kind":"adhoc","request-id":"g019d746b8bb57b459d56976f1ea2be54","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
