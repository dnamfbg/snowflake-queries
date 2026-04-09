-- Query ID: 01c39a50-0112-6029-0000-e307218d29ae
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:40:18.931000+00:00
-- Elapsed: 559ms
-- Environment: FES

select COUNT_113 "row-count" from (select count(1) COUNT_113 from FES_USERS.ROHAN_GULATI.DBFORK_____FES_USERS__ROHAN_GULATI__FANAPP_COHORT_ACTIVITY where ACTIVITY_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and ACTIVITY_DATE <= to_date('2026-12-31', 'YYYY-MM-DD') and INSTALL_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and INSTALL_DATE <= to_date('2026-12-31', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=rgcDnoqLef","kind":"adhoc","request-id":"g019d7467473f7df6aca19a4928aad6e1","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
