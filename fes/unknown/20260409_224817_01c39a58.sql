-- Query ID: 01c39a58-0112-6029-0000-e307218d2d1a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:48:17.609000+00:00
-- Elapsed: 6055ms
-- Environment: FES

select AUDIENCE_NAME "Audience Name", COUNTDISTINCT_18 "CountDistinct of Fangraph Id" from (select AUDIENCE_NAME, count(distinct FANGRAPH_ID) COUNTDISTINCT_18 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS where AUDIENCE_NAME = 'FAN_AllFans_T1' and GENDER = 'FEMALE' group by AUDIENCE_NAME) Q1 order by AUDIENCE_NAME asc limit 349501

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw?:displayNodeId=OqGa5W5CVc","kind":"adhoc","request-id":"g019d746e950e7324bb555bff6fe83998","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
