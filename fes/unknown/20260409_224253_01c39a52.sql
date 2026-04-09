-- Query ID: 01c39a52-0112-6f82-0000-e307218d0d7e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:42:53.423000+00:00
-- Elapsed: 444ms
-- Environment: FES

select PRIVATE_FAN_ID "TopK Value", COUNT_19 "TopK Count" from (select PRIVATE_FAN_ID, count(1) COUNT_19 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by PRIVATE_FAN_ID) Q1 order by COUNT_19 desc, PRIVATE_FAN_ID asc limit 8

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk","kind":"adhoc","request-id":"g019d7469a2a67753a946c3e0a4192156","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
