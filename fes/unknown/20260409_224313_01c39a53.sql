-- Query ID: 01c39a53-0112-6029-0000-e307218d2a42
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:43:13.503000+00:00
-- Elapsed: 331ms
-- Environment: FES

select FANAPP_CHANNEL_LABEL "TopK Value", COUNT_19 "TopK Count", FANAPP_CHANNEL_LABEL_20 "TopK Display" from (select FANAPP_CHANNEL_LABEL, count(1) COUNT_19, FANAPP_CHANNEL_LABEL FANAPP_CHANNEL_LABEL_20 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by FANAPP_CHANNEL_LABEL) Q1 order by COUNT_19 desc, FANAPP_CHANNEL_LABEL_20 asc limit 8

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk","kind":"adhoc","request-id":"g019d7469f139705395cce0091b950514","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
