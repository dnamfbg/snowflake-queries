-- Query ID: 01c39a49-0112-6f82-0000-e307218d0b0e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:33:36.239000+00:00
-- Elapsed: 558ms
-- Environment: FES

select V_18 "Day of Calc", COUNTDISTINCT_20 "Installs", COUNTDISTINCT_19 "Eligible at Install", COUNTDISTINCT_21 "FBG Activiated", COUNTDISTINCT_22 "FanApp Attributed FBG FTU" from (select V_18, count(distinct iff(FTU_ELIGIBLE_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_19, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_20, count(distinct iff(ACTIVATED_FBG_POST_INSTALL = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_21, count(distinct iff(FANAPP_FTU_ATTRIBUTION is not null, PRIVATE_FAN_ID, null)) COUNTDISTINCT_22 from (select PRIVATE_FAN_ID, FANAPP_FTU_ATTRIBUTION, ACTIVATED_FBG_POST_INSTALL, FTU_ELIGIBLE_INSTALL_FLAG, 'Unknown column "[Calc]"' V_18 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU) Q1 group by V_18) Q2 order by V_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d7461223d7b2b8165c1246e981fc8","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
