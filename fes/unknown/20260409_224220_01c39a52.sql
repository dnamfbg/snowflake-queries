-- Query ID: 01c39a52-0112-6806-0000-e307218d3ade
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:42:20.278000+00:00
-- Elapsed: 199ms
-- Environment: FES

select COUNT_113 "row-count" from (select count(1) COUNT_113 from FES_USERS.SANDBOX.FANAPP_COHORT_ACTIVITY where SOURCE_LABEL_OTHER = 'Paid' and ACTIVITY_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and ACTIVITY_DATE <= to_date('2026-12-31', 'YYYY-MM-DD') and INSTALL_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and INSTALL_DATE <= to_date('2026-12-31', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=rgcDnoqLef","kind":"adhoc","request-id":"g019d746920f77a95ba2aeeaebcfd4b80","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
