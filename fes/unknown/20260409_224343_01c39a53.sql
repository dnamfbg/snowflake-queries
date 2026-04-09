-- Query ID: 01c39a53-0112-6f84-0000-e307218cafaa
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:43:43.101000+00:00
-- Elapsed: 76145ms
-- Environment: FES

select COUNT_23 "row-count" from (select count(1) COUNT_23 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS where AUDIENCE_NAME = 'FAN_AllFans_T1') Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw?:displayNodeId=OqGa5W5CVc","kind":"adhoc","request-id":"g019d746a637f775a97cc48c885f174ec","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
