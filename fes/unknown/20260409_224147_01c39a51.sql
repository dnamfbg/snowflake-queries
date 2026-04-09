-- Query ID: 01c39a51-0112-6806-0000-e307218d3ac2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:41:47.972000+00:00
-- Elapsed: 805ms
-- Environment: FES

select DATETRUNC_19 "Time Frame", COUNTDISTINCT_22 "Total Installs", COUNTDISTINCT_21 "Total OSB State Installs", COUNTDISTINCT_20 "Eligible at Install", COUNTDISTINCT_23 "FBG Activiated", DIV_25 "% FBG Activated Post Install", COUNTDISTINCT_24 "FanApp Attributed FBG FTU", DIV_26 "Eligible Install to FanApp CVR" from (select date_trunc(month, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_19, count(distinct iff(ENR_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_20, count(distinct iff(FIRST_OSB_STATE_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_21, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_22, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1 and ENR_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_23, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null and ENR_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_24, COUNTDISTINCT_23 / nullif(COUNTDISTINCT_20, 0) DIV_25, COUNTDISTINCT_24 / nullif(COUNTDISTINCT_20, 0) DIV_26 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_19) Q1 order by DATETRUNC_19 desc nulls last limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d7468a3157061b6d09d1effcb1611","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
