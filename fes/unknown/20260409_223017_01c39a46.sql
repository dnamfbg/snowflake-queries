-- Query ID: 01c39a46-0112-6f86-0000-e307218d12ea
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:30:17.111000+00:00
-- Elapsed: 1212ms
-- Environment: FES

select COUNTDISTINCT_19 "Installs", COUNTDISTINCT_18 "Eligible at Install", COUNTDISTINCT_20 "FBG Activiated", COUNTDISTINCT_21 "FanApp Attributed FBG FTU" from (select count(distinct iff(FTU_ELIGIBLE_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_18, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_19, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_20, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null, PRIVATE_FAN_ID, null)) COUNTDISTINCT_21 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d745e186376c9acd70490ac5805ff","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
