-- Query ID: 01c39a56-0112-6f84-0000-e307218db1f6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:46:42.716000+00:00
-- Elapsed: 77425ms
-- Environment: FES

select AUDIENCE_NAME "Audience Name", COUNTDISTINCT_18 "CountDistinct of Fangraph Id" from (select AUDIENCE_NAME, count(distinct FANGRAPH_ID) COUNTDISTINCT_18 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS where AUDIENCE_NAME = 'FAN_AllFans_T1' group by AUDIENCE_NAME) Q1 order by AUDIENCE_NAME asc limit 24301

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw?:displayNodeId=OqGa5W5CVc","kind":"adhoc","request-id":"g019d746d2272771d8e0b61381bd293b7","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
