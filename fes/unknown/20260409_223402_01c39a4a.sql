-- Query ID: 01c39a4a-0112-6bf9-0000-e307218cfdee
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:34:02.430000+00:00
-- Elapsed: 769ms
-- Environment: FES

select DATETRUNC_19 "Calc", COUNTDISTINCT_21 "Installs", COUNTDISTINCT_20 "Eligible at Install", COUNTDISTINCT_22 "FBG Activiated", COUNTDISTINCT_23 "FanApp Attributed FBG FTU" from (select date_trunc(month, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_19, count(distinct iff(FTU_ELIGIBLE_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_20, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_21, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_22, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null, PRIVATE_FAN_ID, null)) COUNTDISTINCT_23 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_19) Q1 order by DATETRUNC_19 asc limit 262101

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d746188b57518b2cf9414277dce06","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
