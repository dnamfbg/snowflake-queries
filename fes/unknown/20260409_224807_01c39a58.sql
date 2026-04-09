-- Query ID: 01c39a58-0112-6029-0000-e307218d2d16
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:48:07.826000+00:00
-- Elapsed: 2579ms
-- Environment: FES

select GENDER "TopK Value", COUNT_23 "TopK Count", ISNULL_28 "TopK Null Sort" from (select *, GENDER is null ISNULL_28 from (select GENDER, count(1) COUNT_23 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS where AUDIENCE_NAME = 'FAN_AllFans_T1' group by GENDER) Q1) Q2 order by ISNULL_28 desc, COUNT_23 desc, GENDER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw","kind":"adhoc","request-id":"g019d746e6dbb75e493296b77b622f163","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
