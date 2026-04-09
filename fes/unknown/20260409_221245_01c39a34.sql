-- Query ID: 01c39a34-0112-6f84-0000-e307218ca272
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:12:45.250000+00:00
-- Elapsed: 893ms
-- Environment: FES

select PRIVATE_FAN_ID "Private Fan Id", FBG_TENANT_FAN_ID "Fbg Tenant Fan Id", FANAPP_TENANT_FAN_ID "Fanapp Tenant Fan Id", FANAPP_CHANNEL_LABEL "Fanapp Channel Label", FANAPP_SOURCE_LABEL "Fanapp Source Label", FANAPP_PLACEMENT_LABEL "Fanapp Placement Label", FBG_ACQUISITION_CHANNEL "Fbg Acquisition Channel", CAST_18 "Fanapp Install Ts Alk", CAST_19 "Fbg Ftu Ts Alk", CAST_20 "Fbg Reg Ts Alk", FANAPP_FTU_ATTRIBUTION "Fanapp Ftu Attribution", FIRST_INSTALL_STATE "First Install State", FIRST_OSB_STATE_FLAG "First Osb State Flag", ACTIVATED_FBG_POST_INSTALL "Activated Fbg Post Install", FTU_ELIGIBLE_INSTALL_FLAG "Ftu Eligible Install Flag", ENR_INSTALL_FLAG "Enr Install Flag", ENFTU_INSTALL_FLAG "Enftu Install Flag", FTU_ATTRIBUTION "Ftu Attribution" from (select PRIVATE_FAN_ID, FBG_TENANT_FAN_ID, FANAPP_TENANT_FAN_ID, FANAPP_CHANNEL_LABEL, FANAPP_SOURCE_LABEL, FANAPP_PLACEMENT_LABEL, FBG_ACQUISITION_CHANNEL, FANAPP_FTU_ATTRIBUTION, FIRST_INSTALL_STATE, FIRST_OSB_STATE_FLAG, ACTIVATED_FBG_POST_INSTALL, FTU_ELIGIBLE_INSTALL_FLAG, ENR_INSTALL_FLAG, ENFTU_INSTALL_FLAG, FTU_ATTRIBUTION, FANAPP_INSTALL_TS_ALK::timestamp_ltz CAST_18, FBG_FTU_TS_ALK::timestamp_ltz CAST_19, FBG_REG_TS_ALK::timestamp_ltz CAST_20 from FES_USERS.DYLAN_TUCH.FBG_PAID_INSTALL_TO_FTU) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/t/FBG_PAID_INSTALL_TO_FTU-4np6O4zg25SIisl19GC50k","kind":"adhoc","request-id":"g019d744e0bb37336a7e454a78026ea15","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
