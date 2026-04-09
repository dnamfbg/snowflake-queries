-- Query ID: 01c39a3d-0112-6bf9-0000-e307218cf882
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:21:56.359000+00:00
-- Elapsed: 637ms
-- Environment: FES

select DATETRUNC_18 "Day of Fanapp Install Ts Alk", COUNT_20 "Count of Private Fan Id" from (select date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18, count(PRIVATE_FAN_ID) COUNT_20 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU group by DATETRUNC_18) Q1 order by DATETRUNC_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d74567376784cbb94b36c8a25dd98","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
