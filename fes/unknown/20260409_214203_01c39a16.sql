-- Query ID: 01c39a16-0112-6029-0000-e307218b8b32
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:42:03.096000+00:00
-- Elapsed: 1058ms
-- Environment: FES

select COUNT_87 "row-count" from (select count(1) COUNT_87 from MONTEROSA.MONTEROSA_CORE.FANAPP_GAME_RESULTS left join FANGRAPH.PRIVATE_FAN_ID.PFI_CUSTOMER_MART Q2 on FANAPP_GAME_RESULTS.EXTERNAL_ID = Q2.FANAPP_TENANT_FAN_ID) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/CS-Customer-Lookups-60IfF4RUOlf52f043esuKd?:displayNodeId=fH-fON8W1t","kind":"adhoc","request-id":"g019d7431ef4d7bb788e007df8730a139","user-id":"AZr0HVISSWncCdBK80ukPYT6BSiIS","email":"rebecca.licht@betfanatics.com"}
