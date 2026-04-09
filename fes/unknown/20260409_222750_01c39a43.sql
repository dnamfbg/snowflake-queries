-- Query ID: 01c39a43-0112-6f82-0000-e307218d082e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:27:50.923000+00:00
-- Elapsed: 416ms
-- Environment: FES

select DATETRUNC_18 "FanApp Install Time Frame", COUNTDISTINCT_20 "Installs", V_23 "Eligible at Install", COUNTDISTINCT_21 "FBG Activiated", COUNTDISTINCT_22 "FanApp Attributed FBG FTU" from (select date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_20, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_21, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null, PRIVATE_FAN_ID, null)) COUNTDISTINCT_22, 'Incomplete formula.' V_23 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU where PRIVATE_FAN_ID = 'Year' group by DATETRUNC_18) Q1 order by DATETRUNC_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d745bdd6d76aea2cb80434c569c55","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
