-- Query ID: 01c39a35-0112-6029-0000-e307218cbf46
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:13:11.008000+00:00
-- Elapsed: 113ms
-- Environment: FES

select SOURCE_LABEL_OTHER "TopK Value", COUNT_14 "TopK Count", ISNULL_19 "TopK Null Sort" from (select *, SOURCE_LABEL_OTHER is null ISNULL_19 from (select SOURCE_LABEL_OTHER, count(1) COUNT_14 from FES_USERS.ROHAN_GULATI.DBFORK_____FES_USERS__ROHAN_GULATI__FANAPP_PAID_SPEND where "DATE" >= to_date('2025-01-01', 'YYYY-MM-DD') and "DATE" <= to_date('2026-12-31', 'YYYY-MM-DD') group by SOURCE_LABEL_OTHER) Q1) Q2 order by ISNULL_19 desc, COUNT_14 desc, SOURCE_LABEL_OTHER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr","kind":"adhoc","request-id":"g019d744e70437c7686d247cdeacc0547","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
