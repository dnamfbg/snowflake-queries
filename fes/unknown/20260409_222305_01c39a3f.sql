-- Query ID: 01c39a3f-0112-6bf9-0000-e307218cf8be
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:23:05.438000+00:00
-- Elapsed: 1145ms
-- Environment: FES

select DATETRUNC_18 "Day of Fanapp Install Ts Alk", COUNTDISTINCT_21 "Installs", COUNTDISTINCT_20 "Eligible at Install" from (select date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18, count(distinct iff(FTU_ELIGIBLE_INSTALL_FLAG = 1, PRIVATE_FAN_ID, null)) COUNTDISTINCT_20, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_21 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_18) Q1 order by DATETRUNC_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d745781d373588513a2fd1f272239","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
