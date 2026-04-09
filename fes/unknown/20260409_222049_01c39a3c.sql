-- Query ID: 01c39a3c-0112-6806-0000-e307218d326a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:20:49.237000+00:00
-- Elapsed: 2440ms
-- Environment: FES

select DATETRUNC_18 "Day of Fanapp Install Ts Alk", PRIVATE_FAN_ID "Private Fan Id", FBG_TENANT_FAN_ID "Fbg Tenant Fan Id", FANAPP_TENANT_FAN_ID "Fanapp Tenant Fan Id", FANAPP_CHANNEL_LABEL "Fanapp Channel Label", FANAPP_SOURCE_LABEL "Fanapp Source Label", FANAPP_PLACEMENT_LABEL "Fanapp Placement Label", FBG_ACQUISITION_CHANNEL "Fbg Acquisition Channel", CAST_19 "Fanapp Install Ts Alk", CAST_20 "Fbg Ftu Ts Alk", CAST_21 "Fbg Reg Ts Alk", FANAPP_FTU_ATTRIBUTION "Fanapp Ftu Attribution", FIRST_INSTALL_STATE "First Install State", FIRST_OSB_STATE_FLAG "First Osb State Flag", ACTIVATED_FBG_POST_INSTALL "Activated Fbg Post Install", FTU_ELIGIBLE_INSTALL_FLAG "Ftu Eligible Install Flag", ENR_INSTALL_FLAG "Enr Install Flag", ENFTU_INSTALL_FLAG "Enftu Install Flag", FTU_ATTRIBUTION "Ftu Attribution" from (select PRIVATE_FAN_ID, FBG_TENANT_FAN_ID, FANAPP_TENANT_FAN_ID, FANAPP_CHANNEL_LABEL, FANAPP_SOURCE_LABEL, FANAPP_PLACEMENT_LABEL, FBG_ACQUISITION_CHANNEL, FANAPP_FTU_ATTRIBUTION, FIRST_INSTALL_STATE, FIRST_OSB_STATE_FLAG, ACTIVATED_FBG_POST_INSTALL, FTU_ELIGIBLE_INSTALL_FLAG, ENR_INSTALL_FLAG, ENFTU_INSTALL_FLAG, FTU_ATTRIBUTION, date_trunc(day, FANAPP_INSTALL_TS_ALK::timestamp_ltz) DATETRUNC_18, FANAPP_INSTALL_TS_ALK::timestamp_ltz CAST_19, FBG_FTU_TS_ALK::timestamp_ltz CAST_20, FBG_REG_TS_ALK::timestamp_ltz CAST_21 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU) Q1 order by DATETRUNC_18 asc limit 45301

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=lpNf64WMva","kind":"adhoc","request-id":"g019d74556d067b978aa89916108de830","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
