-- Query ID: 01c39a52-0112-6bf9-0000-e307218da07a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:42:35.125000+00:00
-- Elapsed: 16975ms
-- Environment: FES

select AUDIENCE_NAME "TopK Value", COUNT_23 "TopK Count" from (select AUDIENCE_NAME, count(1) COUNT_23 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS group by AUDIENCE_NAME) Q1 order by COUNT_23 desc, AUDIENCE_NAME asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw","kind":"adhoc","request-id":"g019d74695a8a796083add64812661cdd","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
