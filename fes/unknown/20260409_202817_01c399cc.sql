-- Query ID: 01c399cc-0112-6ccc-0000-e3072189e5ba
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:17.253000+00:00
-- Elapsed: 1720ms
-- Environment: FES

select IF_45 "Optco", DATETRUNC_38 "Date", SUM_47 "Sum of Sum of Tier Points Amount", SUM_48 "Sum of Tier Points" from (select DATETRUNC_38, iff(TENANT_ID = '100002', 'FBG', 'Commerce') IF_45, sum(SUM_39) SUM_47, SUM_47 SUM_48 from (select TENANT_ID, date_trunc(day, TRANSACTION_TIMESTAMP) DATETRUNC_38, sum(TIER_POINTS_AMOUNT) SUM_39 from LOYALTY.LOYALTY_INFO.TIER_POINTS_LEDGER_V2 where date_trunc(day, TRANSACTION_TIMESTAMP) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, TRANSACTION_TIMESTAMP) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_38, TENANT_ID) Q1 group by DATETRUNC_38, IF_45) Q2 order by IF_45 asc, DATETRUNC_38 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=0P6IGe6KKh","kind":"adhoc","request-id":"g019d73ee6085751c87a9afe044790662","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
