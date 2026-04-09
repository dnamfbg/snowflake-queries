-- Query ID: 01c39a53-0112-6be5-0000-e307218d727a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:43:00.889000+00:00
-- Elapsed: 558ms
-- Environment: FES

select FANAPP_CHANNEL_LABEL "TopK Value", COUNT_19 "TopK Count" from (select FANAPP_CHANNEL_LABEL, count(1) COUNT_19 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by FANAPP_CHANNEL_LABEL) Q1 order by COUNT_19 desc, FANAPP_CHANNEL_LABEL asc limit 8

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk","kind":"adhoc","request-id":"g019d7469c0057a4dbae67f9995453c3f","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
