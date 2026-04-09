-- Query ID: 01c399d6-0212-6b00-24dd-0703192add9b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:38:56.116000+00:00
-- Elapsed: 1054ms
-- Environment: FBG

select DATETRUNC_32 "Last Geolocation Date (UTC)", DEVICE_UUID_34 "Device ID", SD_ACCO_ID_33 "Shared Device Account ID", SUM_35 "Geolocation Count", DIV_51 "Device % of Geolocation", IF_45 "Shared Device Account Status", NULL_EQ_43, IF_46 "Shared Device Last Geolocation Date", NULL_EQ_36, IF_44 "Shared Device Geolocation Count", NULL_EQ_41, DIV_52 "Shared Device % of Geolocation" from (select date_trunc(second, LAST_GEOLOCATION::timestamp_ltz) DATETRUNC_32, SD_ACCO_ID SD_ACCO_ID_33, DEVICE_UUID DEVICE_UUID_34, sum(GEOLOCATION_CT) SUM_35, equal_null(min(SD_LAST_GEOLOCATION::timestamp_ltz), max(SD_LAST_GEOLOCATION::timestamp_ltz)) NULL_EQ_36, equal_null(min(SD_GEOLOCATION_CT), max(SD_GEOLOCATION_CT)) NULL_EQ_41, equal_null(min(SD_STATUS), max(SD_STATUS)) NULL_EQ_43, iff(NULL_EQ_41, max(SD_GEOLOCATION_CT), null) IF_44, iff(NULL_EQ_43, max(SD_STATUS), null) IF_45, iff(NULL_EQ_36, max(SD_LAST_GEOLOCATION::timestamp_ltz), null) IF_46, SUM_35 / nullif(sum(TOTAL_CT), 0) DIV_51, IF_44 / nullif(sum(SD_TOTAL_CT), 0) DIV_52 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 3213501 group by SD_ACCO_ID, DEVICE_UUID, DATETRUNC_32) Q1 order by DATETRUNC_32 desc nulls last, DEVICE_UUID_34 asc, SD_ACCO_ID_33 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=0z7MNKfYXU","kind":"adhoc","request-id":"g019d73f824a376fca099390b8c73539e","user-id":"jq9eEM8S1jbljCS4KzxiXWhnVMGGN","email":"daniel.westerberg@betfanatics.com"}
