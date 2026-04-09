-- Query ID: 01c39a0c-0112-6b51-0000-e307218b764e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:32:03.204000+00:00
-- Elapsed: 121ms
-- Environment: FES

select BRIDGE_IDENTITY_KEY "Bridge Identity Key", IDENTITY_TYPE "Identity Type", IS_GUEST_FLAG "Is Guest Flag", PRIVATE_FAN_ID "Private Fan Id", FANAPP_TENANT_FAN_ID "Fanapp Tenant Fan Id", CAST_18 "First Active at Utc", CAST_19 "Most Recent Active at Utc", CAST_20 "Most Recent Active Date Utc", FIRST_DEVICE_ID "First Device Id", MOST_RECENT_DEVICE_ID "Most Recent Device Id", FIRST_STATE "First State", MOST_RECENT_STATE "Most Recent State", FIRST_AMPLITUDE_ID "First Amplitude Id", MOST_RECENT_AMPLITUDE_ID "Most Recent Amplitude Id", OSB_TAG "Osb Tag", EVER_OSB_STATE_FLAG "Ever Osb State Flag", CAST_17 "Amplitude Id Array" from (select BRIDGE_IDENTITY_KEY, IDENTITY_TYPE, IS_GUEST_FLAG, PRIVATE_FAN_ID, FANAPP_TENANT_FAN_ID, FIRST_DEVICE_ID, MOST_RECENT_DEVICE_ID, FIRST_STATE, MOST_RECENT_STATE, FIRST_AMPLITUDE_ID, MOST_RECENT_AMPLITUDE_ID, OSB_TAG, EVER_OSB_STATE_FLAG, to_variant(AMPLITUDE_ID_ARRAY) CAST_17, FIRST_ACTIVE_AT_UTC::timestamp_ltz CAST_18, MOST_RECENT_ACTIVE_AT_UTC::timestamp_ltz CAST_19, MOST_RECENT_ACTIVE_DATE_UTC::timestamp_ltz CAST_20 from FES_USERS.SANDBOX.AMPLITUDE_TO_PFI_BRIDGE) Q1 limit 1001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/FanApp-MAU-2BkDb8Xokp7JKzDCsdMD6L?:displayNodeId=zB17WNm7_I","kind":"adhoc","request-id":"g019d7428c740727ba2a8265398f4f75c","user-id":"761znsSQzXm3bXv3Md6ACqJN9CDcw","email":"caroline.wylie@betfanatics.com"}
