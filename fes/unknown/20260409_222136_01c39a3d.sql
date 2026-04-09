-- Query ID: 01c39a3d-0112-6544-0000-e307218ccd82
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:21:36.160000+00:00
-- Elapsed: 1387ms
-- Environment: FES

select DATETRUNC_18 "Day of Fanapp Install Ts Alk" from (select distinct date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU) Q1 order by DATETRUNC_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d745624927c9893f94a10bb90cdb1","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
