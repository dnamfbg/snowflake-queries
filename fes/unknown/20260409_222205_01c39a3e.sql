-- Query ID: 01c39a3e-0112-6b51-0000-e307218d42e2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:22:05.849000+00:00
-- Elapsed: 668ms
-- Environment: FES

select DATETRUNC_18 "Day of Fanapp Install Ts Alk", COUNTDISTINCT_20 "Installs" from (select date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18, count(distinct PRIVATE_FAN_ID) COUNTDISTINCT_20 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_18) Q1 order by DATETRUNC_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d745699797603ab54073748b4549f","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
