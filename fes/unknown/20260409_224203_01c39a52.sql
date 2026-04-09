-- Query ID: 01c39a52-0112-6f84-0000-e307218caf02
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:42:03.185000+00:00
-- Elapsed: 287ms
-- Environment: FES

select COUNT_112 "row-count" from (select count(1) COUNT_112 from FES_USERS.SANDBOX.FANAPP_COHORT_ACTIVITY where SOURCE_LABEL_OTHER = 'Paid' and ACTIVITY_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and ACTIVITY_DATE <= to_date('2026-12-31', 'YYYY-MM-DD') and INSTALL_DATE >= to_date('2025-01-01', 'YYYY-MM-DD') and INSTALL_DATE <= to_date('2026-12-31', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=rgcDnoqLef","kind":"adhoc","request-id":"g019d7468de8177a2a9dcdfafb825d6fa","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
