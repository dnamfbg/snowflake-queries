-- Query ID: 01c39a47-0112-6f86-0000-e307218d13d2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:31:50.256000+00:00
-- Elapsed: 529ms
-- Environment: FES

select PLACEMENT_LABEL "TopK Value", COUNT_11 "TopK Count", PLACEMENT_LABEL_12 "TopK Display" from (select PLACEMENT_LABEL, count(1) COUNT_11, PLACEMENT_LABEL PLACEMENT_LABEL_12 from FES_USERS.SANDBOX.FANAPP_PAID_SPEND group by PLACEMENT_LABEL) Q1 order by COUNT_11 desc, PLACEMENT_LABEL_12 asc limit 8

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr","kind":"adhoc","request-id":"g019d745f84767eaaa74a4a8443a6160b","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
