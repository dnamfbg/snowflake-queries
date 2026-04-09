-- Query ID: 01c39a49-0112-6029-0000-e307218d27c2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:33:50.283000+00:00
-- Elapsed: 740ms
-- Environment: FES

select DATETRUNC_20 "Calc", COUNTDISTINCT_22 "Installs", COUNTDISTINCT_21 "Eligible at Install", COUNTDISTINCT_23 "FBG Activiated", COUNTDISTINCT_24 "FanApp Attributed FBG FTU" from (select date_trunc(year, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_20, count(distinct iff(FTU_ELIGIBLE_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_21, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_22, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_23, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null, PRIVATE_FAN_ID, null)) COUNTDISTINCT_24 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_20) Q1 order by DATETRUNC_20 asc limit 166401

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d7461591b7c77862a59b6dd535cbd","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
