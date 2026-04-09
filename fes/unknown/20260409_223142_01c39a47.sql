-- Query ID: 01c39a47-0112-6bf9-0000-e307218cfc36
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:31:42.249000+00:00
-- Elapsed: 425ms
-- Environment: FES

select PLACEMENT_LABEL "TopK Value", COUNT_11 "TopK Count" from (select PLACEMENT_LABEL, count(1) COUNT_11 from FES_USERS.SANDBOX.FANAPP_PAID_SPEND group by PLACEMENT_LABEL) Q1 order by COUNT_11 desc, PLACEMENT_LABEL asc limit 8

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr","kind":"adhoc","request-id":"g019d745f65297e42af5628ba00c3a85a","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
